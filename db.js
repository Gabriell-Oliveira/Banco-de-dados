 
async function connect() {
    if (global.connection)
        return global.connection.connect();
 
    const { Pool } = require('pg');
    const pool = new Pool({
        connectionString: process.env.CONNECTION_STRING
    });
 
    //apenas testando a conexão
    const client = await pool.connect();
    console.log("Criou pool de conexões no PostgreSQL!");
 
    const res = await client.query('SELECT NOW()');
    console.log(res.rows[0]);
    client.release();
 
    //guardando para usar sempre o mesmo
    global.connection = pool;
    return pool.connect();
}
 
connect();
 

// Função para consultar a view AlunosDisciplinas
async function selectAlunosDisciplinasProfessores() {
    const client = await connect();
    const result = await client.query('SELECT * FROM AlunosDisciplinasProfessores');
    return result.rows;
  }

// Função para adicionar um aluno
async function adicionarAluno(matricula, nome, endereco, disciplina_id) {
    const client = await connect();
    await client.query('SELECT adicionar_aluno($1, $2, $3, $4)', [
      matricula,
      nome,
      endereco,
      disciplina_id
    ]);
  }

  // Função para atualizar um professor
async function atualizarProfessor(professor_id, nome, endereco) {
    const client = await connect();
    await client.query('SELECT atualizar_professor($1, $2, $3)', [
      professor_id,
      nome,
      endereco
    ]);
  }

  // Stored Procedure para deletar um aluno
async function deletarAluno(aluno_id) {
  const client = await connect();
  await client.query('CALL deletar_aluno($1)', [aluno_id]); // Chamando a procedure que deleta o aluno
  client.release();
}

  // Função para listar todos os alunos
async function selectAlunosDeletados() {
  const client = await connect();
  const result = await client.query('SELECT * FROM AlunosDeletados;'); // Buscando todos os alunos da tabela "Alunos"
  client.release();
  return result.rows;
}

// Função para consultar a Tabela Alunos
async function selectAlunos() {
  const client = await connect();
  const result = await client.query('Select * from Alunos;');
  return result.rows;
}

// Função para consultar a Tabela Professor
async function selectProfessores() {
  const client = await connect();
  const result = await client.query('SELECT * FROM Professores');
  return result.rows;
}

module.exports = { 
    selectAlunosDisciplinasProfessores,
    adicionarAluno,
    atualizarProfessor,
    deletarAluno,
    selectAlunosDeletados,
    selectAlunos,
    selectProfessores,
}
