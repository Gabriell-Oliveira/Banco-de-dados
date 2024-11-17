require("dotenv").config();
 
const db = require("./db");
 
const port = process.env.PORT;
 
const express = require('express'); 

const app = express();

app.use(express.json());

  // Endpoint GET para obter dados da view AlunosDisciplinasProfessores
app.get('/alunos-disciplinas-professor', async (req, res) => {
      const alunosDisciplinas = await db.selectAlunosDisciplinasProfessores();
      res.json(alunosDisciplinas);
    
  });

// Endpoint POST para adicionar um aluno usando uma função simples
app.post('/funcoes/adicionar-aluno', async (req, res) => {
    const { matricula, nome, endereco,disciplina_id } = req.body;
      await db.adicionarAluno(matricula, nome, endereco, disciplina_id);
      res.status(201).send('Aluno adicionado com sucesso.');
    
  });

// Endpoint PUT para atualizar os dados de um professor usando uma função PL/pgSQL
app.put('/funcoes/atualizar-professor/:professor_id', async (req, res) => {
    const { professor_id } = req.params;
    const { nome, endereco } = req.body;
      await db.atualizarProfessor(professor_id, nome, endereco);
      res.send('Professor atualizado com sucesso.');
    
  });
  
// Endpoint DELETE para deletar um Aluno usando uma stored procedure
app.delete('/procedures/deletar-aluno/:aluno_id', async (req, res) => {
  const { aluno_id } = req.params;
    await db.deletarAluno(aluno_id); // Chamando o método que deleta o aluno
    res.send('Aluno deletado com sucesso.');
 
});

  // Endpoint GET para listar todos os Alunos Deletados
  app.get('/alunos-deletados', async (req, res) => {
      const alunos = await db.selectAlunosDeletados(); // Chamando o método que lista todos os alunos
      res.json(alunos);
    
  });

  // Endpoint GET para listar a tabela com todos os Alunos 
  app.get('/alunos', async (req, res) => {
    const alunosDisciplinas = await db.selectAlunos();
    res.json(alunosDisciplinas);
  
});

// Endpoint GET para listar a tabela com todos os Professores 
app.get('/professor', async (req, res) => {
  const alunosDisciplinas = await db.selectProfessores();
  res.json(alunosDisciplinas);

});

app.listen(port);

console.log("Backend rodando");

