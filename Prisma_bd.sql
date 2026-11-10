-- =========================================================
-- PROJETO PRISMA
-- =========================================================
drop database Prisma;
CREATE DATABASE Prisma;
USE Prisma;

-- =========================================================
-- TABELA DE USUÁRIOS
-- =========================================================

CREATE TABLE Usuarios (
    usuario_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(254) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('professor', 'aluno') NOT NULL
);

-- =========================================================
-- TABELA DE PROFESSORES
-- =========================================================

CREATE TABLE Professores (
    id BIGINT UNSIGNED PRIMARY KEY,
    data_nascimento DATE NOT NULL,
    licenciatura VARCHAR(150) NOT NULL,

    CONSTRAINT fk_professores_usuario
        FOREIGN KEY (id)
        REFERENCES usuarios(usuario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- TABELA DE VÍDEOS
-- =========================================================

CREATE TABLE Videos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    professor_id BIGINT UNSIGNED NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    materia VARCHAR(100) NOT NULL,
    serie_escolar VARCHAR(60),
    url_video TEXT NOT NULL,

    status ENUM(
        'rascunho',
        'publicado',
        'arquivado'
    ) NOT NULL DEFAULT 'publicado',

    data_publicacao DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    KEY idx_videos_professor (professor_id),
    KEY idx_videos_materia (materia),
    KEY idx_videos_status_data (status, data_publicacao),

    CONSTRAINT fk_videos_professor
        FOREIGN KEY (professor_id)
        REFERENCES professores(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- TABELA DE QUIZ
-- =========================================================

CREATE TABLE Quiz (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    video_id BIGINT UNSIGNED NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    data_criacao DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_quiz_video
        UNIQUE (video_id),

    CONSTRAINT fk_quiz_video
        FOREIGN KEY (video_id)
        REFERENCES videos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- TABELA DE PERGUNTAS
-- =========================================================

CREATE TABLE Perguntas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    quiz_id BIGINT UNSIGNED NOT NULL,
    enunciado TEXT NOT NULL,
    ordem INT UNSIGNED NOT NULL,
    pontos DECIMAL(6,2) NOT NULL DEFAULT 1.00,

    CONSTRAINT fk_perguntas_quiz
        FOREIGN KEY (quiz_id)
        REFERENCES quiz(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_perguntas_ordem
        CHECK (ordem > 0),

    CONSTRAINT ck_perguntas_pontos
        CHECK (pontos > 0),

    CONSTRAINT uq_quiz_ordem
        UNIQUE (quiz_id, ordem),

    KEY idx_perguntas_quiz (quiz_id)
);

-- =========================================================
-- TABELA DE ALTERNATIVAS
-- =========================================================

CREATE TABLE Alternativas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pergunta_id BIGINT UNSIGNED NOT NULL,
    texto VARCHAR(255) NOT NULL,
    correta BOOLEAN NOT NULL,

    CONSTRAINT fk_alternativas_pergunta
        FOREIGN KEY (pergunta_id)
        REFERENCES perguntas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- =========================================================
-- TABELA DE TENTATIVAS
-- =========================================================

CREATE TABLE Tentativas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    aluno_id BIGINT UNSIGNED NOT NULL,
    quiz_id BIGINT UNSIGNED NOT NULL,

    pontuacao DECIMAL(5,2),

    data_tentativa DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tentativas_aluno
        FOREIGN KEY (aluno_id)
        REFERENCES usuarios(usuario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tentativas_quiz
        FOREIGN KEY (quiz_id)
        REFERENCES quiz(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- TABELA DE RESPOSTAS
-- =========================================================

CREATE TABLE Respostas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    tentativa_id BIGINT UNSIGNED NOT NULL,
    pergunta_id BIGINT UNSIGNED NOT NULL,
    alternativa_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_respostas_tentativa
        FOREIGN KEY (tentativa_id)
        REFERENCES tentativas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_respostas_pergunta
        FOREIGN KEY (pergunta_id)
        REFERENCES perguntas(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_respostas_alternativa
        FOREIGN KEY (alternativa_id)
        REFERENCES alternativas(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- =========================================================
-- 10. CONSULTAS PARA TESTAR O BANCO
-- =========================================================

-- Conferir se as tabelas foram criadas.
SHOW TABLES;
select * from Usuarios;
select * from Professores;
select * from Videos;
select * from Quiz;
select * from Perguntas;
select * from Alternativas;
select * from Tentativas;