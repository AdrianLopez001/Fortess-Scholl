CREATE TABLE usuarios (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    papel VARCHAR(20) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trilhas (
    id BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    nivel VARCHAR(20) NOT NULL,
    ordem INT NOT NULL
);

CREATE TABLE modulos (
    id BIGSERIAL PRIMARY KEY,
    trilha_id BIGINT NOT NULL REFERENCES trilhas(id) ON DELETE CASCADE,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    conteudo_markdown TEXT,
    ordem INT NOT NULL
);

CREATE TABLE exercicios (
    id BIGSERIAL PRIMARY KEY,
    modulo_id BIGINT NOT NULL REFERENCES modulos(id) ON DELETE CASCADE,
    titulo VARCHAR(150) NOT NULL,
    enunciado TEXT NOT NULL,
    codigo_template TEXT,
    testes_junit_code TEXT NOT NULL,
    ordem INT NOT NULL
);

CREATE TABLE submissoes (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    exercicio_id BIGINT NOT NULL REFERENCES exercicios(id) ON DELETE CASCADE,
    codigo_enviado TEXT NOT NULL,
    status VARCHAR(30) NOT NULL,
    detalhes_erro TEXT,
    data_submissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE progresso_modulos (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    modulo_id BIGINT NOT NULL REFERENCES modulos(id) ON DELETE CASCADE,
    status VARCHAR(30) NOT NULL,
    data_conclusao TIMESTAMP,
    CONSTRAINT uk_usuario_modulo UNIQUE (usuario_id, modulo_id)
);
