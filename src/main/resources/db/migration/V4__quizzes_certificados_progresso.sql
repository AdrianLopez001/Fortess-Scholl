-- Tabela de Quizzes Teóricos
CREATE TABLE quizzes (
    id BIGSERIAL PRIMARY KEY,
    modulo_id BIGINT NOT NULL REFERENCES modulos(id) ON DELETE CASCADE,
    pergunta TEXT NOT NULL,
    ordem INT NOT NULL
);

-- Tabela de Opções de Resposta do Quiz
CREATE TABLE quiz_opcoes (
    id BIGSERIAL PRIMARY KEY,
    quiz_id BIGINT NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    texto_opcao TEXT NOT NULL,
    is_correta BOOLEAN NOT NULL DEFAULT FALSE
);

-- Tabela de Respostas enviadas pelos Alunos
CREATE TABLE quiz_respostas (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    quiz_id BIGINT NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    opcao_selecionada_id BIGINT NOT NULL REFERENCES quiz_opcoes(id) ON DELETE CASCADE,
    correto BOOLEAN NOT NULL,
    data_resposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_usuario_quiz UNIQUE (usuario_id, quiz_id)
);

-- Tabela de Certificados Oficiais Gerados
CREATE TABLE certificados (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    trilha_id BIGINT NOT NULL REFERENCES trilhas(id) ON DELETE CASCADE,
    codigo_validacao VARCHAR(64) UNIQUE NOT NULL,
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_usuario_trilha_cert UNIQUE (usuario_id, trilha_id)
);

-- Seed de Quizzes do Módulo 1 (Sintaxe Básica)
INSERT INTO quizzes (id, modulo_id, pergunta, ordem) VALUES
(1, 1, 'Qual é o tamanho na memória do tipo primitivo "int" em Java?', 1),
(2, 1, 'Qual das alternativas representa a declaração correta de uma constante em Java?', 2);

INSERT INTO quiz_opcoes (id, quiz_id, texto_opcao, is_correta) VALUES
(1, 1, '8 bits', FALSE),
(2, 1, '16 bits', FALSE),
(3, 1, '32 bits', TRUE),
(4, 1, '64 bits', FALSE),

(5, 2, 'const int VALOR = 10;', FALSE),
(6, 2, 'final int VALOR = 10;', TRUE),
(7, 2, 'static int VALOR = 10;', FALSE),
(8, 2, 'immutable int VALOR = 10;', FALSE);

-- Seed de Quizzes do Módulo 2 (Estruturas de Controle)
INSERT INTO quizzes (id, modulo_id, pergunta, ordem) VALUES
(3, 2, 'No Java moderno (Java 14+), qual palavra-chave/sintaxe é usada no switch para retornar um valor diretamente?', 1);

INSERT INTO quiz_opcoes (id, quiz_id, texto_opcao, is_correta) VALUES
(9, 3, 'return', FALSE),
(10, 3, 'yield ou arrow syntax (->)', TRUE),
(11, 3, 'break', FALSE),
(12, 3, 'emit', FALSE);

-- Seed de Quizzes do Módulo 4 (POO Básica)
INSERT INTO quizzes (id, modulo_id, pergunta, ordem) VALUES
(4, 4, 'O que o modificador de acesso "private" garante em uma classe Java?', 1);

INSERT INTO quiz_opcoes (id, quiz_id, texto_opcao, is_correta) VALUES
(13, 4, 'Acesso permitido de qualquer pacote do projeto.', FALSE),
(14, 4, 'Acesso restrito apenas aos membros da própria classe.', TRUE),
(15, 4, 'Acesso permitido para subclasses no mesmo pacote.', FALSE),
(16, 4, 'Acesso exclusivo para métodos estáticos.', FALSE);
