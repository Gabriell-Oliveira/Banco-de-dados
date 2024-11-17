-- Criar um novo banco de dados
CREATE DATABASE ESCOLA;

-- Consultar os dados da tabela 
Select * from Alunos;

-- Crie a tabela "Alunos"
CREATE TABLE Alunos (
    matricula INT PRIMARY KEY,
    nome VARCHAR(50),
    data_nascimento DATE,
    endereco VARCHAR(100),
	disciplina_id INT,
	FOREIGN KEY (disciplina_id) REFERENCES Disciplinas(disciplina_id)
);
    
-- Consultar os dados da tabela
SELECT * FROM disciplinas;


-- Cria a tabela "Disciplina"
    CREATE TABLE Disciplinas (
    disciplina_id INT PRIMARY KEY,
    nome VARCHAR(50),
	professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES Professores(professor_id)
     
    );

-- Consultar os dados da tabela
SELECT * FROM Professores;

CREATE TABLE Professores (
    professor_id INT PRIMARY KEY,
    nome VARCHAR(50),
    endereco VARCHAR(100)
);

-- Inserindo dados na tabela "Alunos"
INSERT INTO alunos (matricula, Nome, data_nascimento, endereco, disciplina_id)
values
    (0102, 'Paulo', '2000-11-12', 'Centro', 60),
    (0304, 'Maria', '2001-06-03', 'Pirambu', 50),
    (0506,  'Joao', '2003-05-28', 'Bom jardim', 70),
	(0708, 'Eduardo', '2004-08-22', 'Aldeota', 90),
    (0910, 'Joana', '2005-03-20', 'Beira Mar', 80);
	
-- Inserindo dados na tabela "Professores"	
INSERT INTO Professores (professor_id, Nome, endereco)
values
	    (10, 'Fernanda', 'Papicu'),
    (15, 'Lucas', 'jacarecanga'),
    ('20', 'Adriana', 'Barra do Ceará'),
	('30', 'Lucia', 'Aldeota'),
    ('40', 'Roberta', 'Centro');
    
    -- Inserindo dados na tabela "Disciplinas"
INSERT INTO Disciplinas (disciplina_id, Nome, professor_id)
values
 ('60', 'Matematica', '15'),
    (50, 'Portugues', '10'),
    (70, 'Historia', '40' ),
	('90', 'Ciencia', '20' ),
    ('80', 'Geografia', '30');

-- Criando View para ver quais alunos e professores estão em cada diciplina
CREATE VIEW AlunosDisciplinasProfessores AS
SELECT 
    a.matricula,
    a.nome AS aluno_nome,
    d.nome AS disciplina_nome,
    p.nome AS professor_nome
FROM 
    Alunos a
JOIN 
    Disciplinas d ON a.disciplina_id = d.disciplina_id
JOIN 
    Professores p ON d.professor_id = p.professor_id;

-- chamando a view
SELECT * FROM AlunosDisciplinasProfessores;

-- Função simples para adicionar aluno
CREATE OR REPLACE FUNCTION adicionar_aluno(p_matricula INT, p_nome VARCHAR, p_data_nascimento DATE, p_endereco VARCHAR, p_disciplina_id INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Alunos(matricula, nome, data_nascimento, endereco, disciplina_id)
    VALUES (p_matricula, p_nome, p_data_nascimento, p_endereco, p_disciplina_id);
END;
$$ LANGUAGE plpgsql;

-- Função PL/pgSQL para atualizar os dados do professor
CREATE OR REPLACE FUNCTION atualizar_professor(p_professor_id INT, p_nome VARCHAR, p_endereco VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE Professores
    SET nome = p_nome, endereco = p_endereco
    WHERE professor_id = p_professor_id;
END;
$$ LANGUAGE plpgsql;

-- criando o Stored procedure para deletar o profesor
CREATE OR REPLACE PROCEDURE deletar_professor(p_professor_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Professores
    WHERE professor_id = p_professor_id;
END;
$$;

-- Função para registrar professores deletados
CREATE OR REPLACE FUNCTION registrar_professor_deletado()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Professor deletado: % - Nome: % - Endereço: %', OLD.professor_id, OLD.nome, OLD.endereco;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- Criar a trigger para registrar os professores deletados
CREATE TRIGGER trigger_registrar_professor_deletado
AFTER DELETE ON Professores
FOR EACH ROW EXECUTE FUNCTION registrar_professor_deletado();
