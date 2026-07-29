package com.techsoluctionsrn.plataforma_ensino_java.dto;

import java.util.List;

public class QuizDto {

    public static class QuizResponseDto {
        private Long id;
        private Long moduloId;
        private String pergunta;
        private Integer ordem;
        private List<QuizOpcaoDto> opcoes;
        private boolean respondido;
        private Boolean acertou;

        public QuizResponseDto() {}

        public QuizResponseDto(Long id, Long moduloId, String pergunta, Integer ordem, List<QuizOpcaoDto> opcoes, boolean respondido, Boolean acertou) {
            this.id = id;
            this.moduloId = moduloId;
            this.pergunta = pergunta;
            this.ordem = ordem;
            this.opcoes = opcoes;
            this.respondido = respondido;
            this.acertou = acertou;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public Long getModuloId() { return moduloId; }
        public void setModuloId(Long moduloId) { this.moduloId = moduloId; }

        public String getPergunta() { return pergunta; }
        public void setPergunta(String pergunta) { this.pergunta = pergunta; }

        public Integer getOrdem() { return ordem; }
        public void setOrdem(Integer ordem) { this.ordem = ordem; }

        public List<QuizOpcaoDto> getOpcoes() { return opcoes; }
        public void setOpcoes(List<QuizOpcaoDto> opcoes) { this.opcoes = opcoes; }

        public boolean isRespondido() { return respondido; }
        public void setRespondido(boolean respondido) { this.respondido = respondido; }

        public Boolean getAcertou() { return acertou; }
        public void setAcertou(Boolean acertou) { this.acertou = acertou; }

        public static QuizResponseDtoBuilder builder() { return new QuizResponseDtoBuilder(); }

        public static class QuizResponseDtoBuilder {
            private Long id;
            private Long moduloId;
            private String pergunta;
            private Integer ordem;
            private List<QuizOpcaoDto> opcoes;
            private boolean respondido;
            private Boolean acertou;

            public QuizResponseDtoBuilder id(Long id) { this.id = id; return this; }
            public QuizResponseDtoBuilder moduloId(Long moduloId) { this.moduloId = moduloId; return this; }
            public QuizResponseDtoBuilder pergunta(String pergunta) { this.pergunta = pergunta; return this; }
            public QuizResponseDtoBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
            public QuizResponseDtoBuilder opcoes(List<QuizOpcaoDto> opcoes) { this.opcoes = opcoes; return this; }
            public QuizResponseDtoBuilder respondido(boolean respondido) { this.respondido = respondido; return this; }
            public QuizResponseDtoBuilder acertou(Boolean acertou) { this.acertou = acertou; return this; }

            public QuizResponseDto build() {
                return new QuizResponseDto(id, moduloId, pergunta, ordem, opcoes, respondido, acertou);
            }
        }
    }

    public static class QuizOpcaoDto {
        private Long id;
        private String textoOpcao;

        public QuizOpcaoDto() {}

        public QuizOpcaoDto(Long id, String textoOpcao) {
            this.id = id;
            this.textoOpcao = textoOpcao;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getTextoOpcao() { return textoOpcao; }
        public void setTextoOpcao(String textoOpcao) { this.textoOpcao = textoOpcao; }
    }

    public static class RespostaQuizRequest {
        private Long quizId;
        private Long opcaoId;

        public RespostaQuizRequest() {}

        public RespostaQuizRequest(Long quizId, Long opcaoId) {
            this.quizId = quizId;
            this.opcaoId = opcaoId;
        }

        public Long getQuizId() { return quizId; }
        public void setQuizId(Long quizId) { this.quizId = quizId; }

        public Long getOpcaoId() { return opcaoId; }
        public void setOpcaoId(Long opcaoId) { this.opcaoId = opcaoId; }
    }

    public static class RespostaQuizResponse {
        private boolean correto;
        private String mensagem;

        public RespostaQuizResponse() {}

        public RespostaQuizResponse(boolean correto, String mensagem) {
            this.correto = correto;
            this.mensagem = mensagem;
        }

        public boolean isCorreto() { return correto; }
        public void setCorreto(boolean correto) { this.correto = correto; }

        public String getMensagem() { return mensagem; }
        public void setMensagem(String mensagem) { this.mensagem = mensagem; }
    }
}
