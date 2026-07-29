package com.techsoluctionsrn.plataforma_ensino_java.dto;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public class SubmissaoDto {

    public static class SubmissaoRequest {
        @NotNull(message = "O ID do exercício é obrigatório")
        private Long exercicioId;

        @NotBlank(message = "O código enviado não pode estar em branco")
        private String codigoEnviado;

        public SubmissaoRequest() {}

        public SubmissaoRequest(Long exercicioId, String codigoEnviado) {
            this.exercicioId = exercicioId;
            this.codigoEnviado = codigoEnviado;
        }

        public Long getExercicioId() { return exercicioId; }
        public void setExercicioId(Long exercicioId) { this.exercicioId = exercicioId; }

        public String getCodigoEnviado() { return codigoEnviado; }
        public void setCodigoEnviado(String codigoEnviado) { this.codigoEnviado = codigoEnviado; }
    }

    public static class SubmissaoResponse {
        private Long id;
        private Long exercicioId;
        private StatusSubmissao status;
        private String detalhesErro;
        private String output;
        private LocalDateTime dataSubmissao;
        private boolean moduloConcluido;
        // Campos do sistema profissional
        private int pontosGanhos;
        private int xpTotalUsuario;
        private int tentativa;
        private String dica;
        private double percentualModulo;
        private String nivelDificuldade;

        public SubmissaoResponse() {}

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public Long getExercicioId() { return exercicioId; }
        public void setExercicioId(Long exercicioId) { this.exercicioId = exercicioId; }

        public StatusSubmissao getStatus() { return status; }
        public void setStatus(StatusSubmissao status) { this.status = status; }

        public String getDetalhesErro() { return detalhesErro; }
        public void setDetalhesErro(String detalhesErro) { this.detalhesErro = detalhesErro; }

        public String getOutput() { return output; }
        public void setOutput(String output) { this.output = output; }

        public LocalDateTime getDataSubmissao() { return dataSubmissao; }
        public void setDataSubmissao(LocalDateTime dataSubmissao) { this.dataSubmissao = dataSubmissao; }

        public boolean isModuloConcluido() { return moduloConcluido; }
        public void setModuloConcluido(boolean moduloConcluido) { this.moduloConcluido = moduloConcluido; }

        public int getPontosGanhos() { return pontosGanhos; }
        public void setPontosGanhos(int pontosGanhos) { this.pontosGanhos = pontosGanhos; }

        public int getXpTotalUsuario() { return xpTotalUsuario; }
        public void setXpTotalUsuario(int xpTotalUsuario) { this.xpTotalUsuario = xpTotalUsuario; }

        public int getTentativa() { return tentativa; }
        public void setTentativa(int tentativa) { this.tentativa = tentativa; }

        public String getDica() { return dica; }
        public void setDica(String dica) { this.dica = dica; }

        public double getPercentualModulo() { return percentualModulo; }
        public void setPercentualModulo(double percentualModulo) { this.percentualModulo = percentualModulo; }

        public String getNivelDificuldade() { return nivelDificuldade; }
        public void setNivelDificuldade(String nivelDificuldade) { this.nivelDificuldade = nivelDificuldade; }

        public static SubmissaoResponseBuilder builder() { return new SubmissaoResponseBuilder(); }

        public static class SubmissaoResponseBuilder {
            private Long id;
            private Long exercicioId;
            private StatusSubmissao status;
            private String detalhesErro;
            private String output;
            private LocalDateTime dataSubmissao;
            private boolean moduloConcluido;
            private int pontosGanhos;
            private int xpTotalUsuario;
            private int tentativa;
            private String dica;
            private double percentualModulo;
            private String nivelDificuldade;

            public SubmissaoResponseBuilder id(Long id) { this.id = id; return this; }
            public SubmissaoResponseBuilder exercicioId(Long exercicioId) { this.exercicioId = exercicioId; return this; }
            public SubmissaoResponseBuilder status(StatusSubmissao status) { this.status = status; return this; }
            public SubmissaoResponseBuilder detalhesErro(String detalhesErro) { this.detalhesErro = detalhesErro; return this; }
            public SubmissaoResponseBuilder output(String output) { this.output = output; return this; }
            public SubmissaoResponseBuilder dataSubmissao(LocalDateTime dataSubmissao) { this.dataSubmissao = dataSubmissao; return this; }
            public SubmissaoResponseBuilder moduloConcluido(boolean moduloConcluido) { this.moduloConcluido = moduloConcluido; return this; }
            public SubmissaoResponseBuilder pontosGanhos(int pontosGanhos) { this.pontosGanhos = pontosGanhos; return this; }
            public SubmissaoResponseBuilder xpTotalUsuario(int xpTotalUsuario) { this.xpTotalUsuario = xpTotalUsuario; return this; }
            public SubmissaoResponseBuilder tentativa(int tentativa) { this.tentativa = tentativa; return this; }
            public SubmissaoResponseBuilder dica(String dica) { this.dica = dica; return this; }
            public SubmissaoResponseBuilder percentualModulo(double percentualModulo) { this.percentualModulo = percentualModulo; return this; }
            public SubmissaoResponseBuilder nivelDificuldade(String nivelDificuldade) { this.nivelDificuldade = nivelDificuldade; return this; }

            public SubmissaoResponse build() {
                SubmissaoResponse r = new SubmissaoResponse();
                r.setId(id); r.setExercicioId(exercicioId); r.setStatus(status);
                r.setDetalhesErro(detalhesErro); r.setOutput(output);
                r.setDataSubmissao(dataSubmissao); r.setModuloConcluido(moduloConcluido);
                r.setPontosGanhos(pontosGanhos); r.setXpTotalUsuario(xpTotalUsuario);
                r.setTentativa(tentativa); r.setDica(dica);
                r.setPercentualModulo(percentualModulo); r.setNivelDificuldade(nivelDificuldade);
                return r;
            }
        }
    }
}
