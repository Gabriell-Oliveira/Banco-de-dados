# API para Gerenciamento de Alunos, Professores e Disciplinas

Este repositório contém a implementação de uma API RESTful que interage com um banco de dados PostgreSQL. A API expõe endpoints para realizar operações de CRUD (criar, ler, atualizar, deletar) sobre alunos, professores e disciplinas. Utilizando JavaScript, a API é construída com o framework **Express.js** e interage com o PostgreSQL através de **funções**, **procedures** e **views**. O teste da API pode ser realizado utilizando a ferramenta **Postman**.

## Banco de Dados

A API se conecta ao banco de dados PostgreSQL, onde o esquema de dados consiste em três tabelas principais: **Alunos**, **Professores** e **Disciplinas**. Além disso, foram implementadas funções PL/pgSQL, procedures e triggers para facilitar a manipulação e a integridade dos dados.

### Estrutura do Banco de Dados

#### Tabelas
1. **Alunos**
   - `matricula` (INT) - Chave primária
   - `nome` (VARCHAR)
   - `data_nascimento` (DATE)
   - `endereco` (VARCHAR)
   - `disciplina_id` (INT) - Chave estrangeira referenciando a tabela **Disciplinas**
   
2. **Disciplinas**
   - `disciplina_id` (INT) - Chave primária
   - `nome` (VARCHAR)
   - `professor_id` (INT) - Chave estrangeira referenciando a tabela **Professores**
   
3. **Professores**
   - `professor_id` (INT) - Chave primária
   - `nome` (VARCHAR)
   - `endereco` (VARCHAR)

#### Funções e Procedures
- **Função** `adicionar_aluno`: Adiciona um novo aluno à tabela **Alunos**.
- **Função** `atualizar_professor`: Atualiza os dados de um professor na tabela **Professores**.
- **Stored Procedure** `deletar_professor`: Deleta um professor da tabela **Professores**.
- **Trigger** `trigger_registrar_professor_deletado`: Registra informações sobre os professores deletados.
- **View** `AlunosDisciplinasProfessores`: Exibe os dados dos alunos juntamente com as disciplinas e professores a que estão vinculados.

## Como Rodar a API

### Pré-requisitos

Antes de rodar a API, é necessário garantir que o PostgreSQL esteja instalado e configurado corretamente. Além disso, instale as dependências do projeto com os seguintes passos:

1. Clone o repositório:

```bash
git clone https://github.com/Gabriell-Oliveira/Banco-de-dados.git
cd Banco-de-dados
```

2. Instale as dependências:

```bash
npm install
```

3. Configure a variável de ambiente `CONNECTION_STRING` com a URL de conexão do seu banco PostgreSQL no arquivo `.env`.

Exemplo de configuração do arquivo `.env`:

```env
PORT=3000
CONNECTION_STRING=postgres://usuario:senha@localhost:5432/ESCOLA
```

4. Inicie o servidor:

```bash
npm start
```

A API estará disponível em `http://localhost:3000`.

## Endpoints

Aqui estão os principais endpoints da API, que podem ser testados com o Postman.

### 1. **GET /alunos-disciplinas-professor**
Recupera os dados da **view** `AlunosDisciplinasProfessores`, mostrando a relação entre alunos, disciplinas e professores.

**Exemplo de resposta:**

```json
[
  {
    "matricula": 0102,
    "aluno_nome": "Paulo",
    "disciplina_nome": "Matematica",
    "professor_nome": "Lucas"
  },
  {
    "matricula": 0304,
    "aluno_nome": "Maria",
    "disciplina_nome": "Portugues",
    "professor_nome": "Fernanda"
  }
]
```

### 2. **POST /funcoes/adicionar-aluno**
Adiciona um novo aluno utilizando a função `adicionar_aluno`.

**Body da requisição:**

```json
{
  "matricula": 1234,
  "nome": "Carlos",
  "endereco": "Aldeota",
  "disciplina_id": 60
}
```

**Resposta:**

```json
{
  "message": "Aluno adicionado com sucesso."
}
```

### 3. **PUT /funcoes/atualizar-professor/:professor_id**
Atualiza os dados de um professor utilizando a função `atualizar_professor`.

**Body da requisição:**

```json
{
  "nome": "Roberta",
  "endereco": "Centro"
}
```

**Resposta:**

```json
{
  "message": "Professor atualizado com sucesso."
}
```

### 4. **DELETE /procedures/deletar-aluno/:aluno_id**
Deleta um aluno utilizando a stored procedure `deletar_aluno`.

**Exemplo de resposta:**

```json
{
  "message": "Aluno deletado com sucesso."
}
```

### 5. **GET /alunos-deletados**
Recupera todos os alunos que foram deletados (de acordo com a trigger `registrar_professor_deletado`).

**Exemplo de resposta:**

```json
[
  {
    "matricula": 1234,
    "nome": "Carlos"
  }
]
```

### 6. **GET /alunos**
Recupera todos os alunos cadastrados na tabela **Alunos**.

**Exemplo de resposta:**

```json
[
  {
    "matricula": 0102,
    "nome": "Paulo",
    "data_nascimento": "2000-11-12",
    "endereco": "Centro",
    "disciplina_id": 60
  },
  {
    "matricula": 0304,
    "nome": "Maria",
    "data_nascimento": "2001-06-03",
    "endereco": "Pirambu",
    "disciplina_id": 50
  }
]
```

### 7. **GET /professor**
Recupera todos os professores cadastrados na tabela **Professores**.

**Exemplo de resposta:**

```json
[
  {
    "professor_id": 10,
    "nome": "Fernanda",
    "endereco": "Papicu"
  },
  {
    "professor_id": 15,
    "nome": "Lucas",
    "endereco": "Jacarecanga"
  }
]
```

## Testando com o Postman

1. Abra o Postman e configure as requisições HTTP conforme os exemplos acima.
2. Para testar, envie as requisições para os endpoints configurados.
3. Verifique as respostas e ajuste conforme necessário.
