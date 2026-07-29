package com.techsoluctionsrn.plataforma_ensino_java.dto;

import java.time.LocalDateTime;

public class CertificadoDto {
    private String usuarioNome;
    private String usuarioEmail;
    private String trilhaTitulo;
    private String codigoValidacao;
    private LocalDateTime dataEmissao;

    public CertificadoDto() {}

    public CertificadoDto(String usuarioNome, String usuarioEmail, String trilhaTitulo, String codigoValidacao, LocalDateTime dataEmissao) {
        this.usuarioNome = usuarioNome;
        this.usuarioEmail = usuarioEmail;
        this.trilhaTitulo = trilhaTitulo;
        this.codigoValidacao = codigoValidacao;
        this.dataEmissao = dataEmissao;
    }

    public String getUsuarioNome() { return usuarioNome; }
    public void setUsuarioNome(String usuarioNome) { this.usuarioNome = usuarioNome; }

    public String getUsuarioEmail() { return usuarioEmail; }
    public void setUsuarioEmail(String usuarioEmail) { this.usuarioEmail = usuarioEmail; }

    public String getTrilhaTitulo() { return trilhaTitulo; }
    public void setTrilhaTitulo(String trilhaTitulo) { this.trilhaTitulo = trilhaTitulo; }

    public String getCodigoValidacao() { return codigoValidacao; }
    public void setCodigoValidacao(String codigoValidacao) { this.codigoValidacao = codigoValidacao; }

    public LocalDateTime getDataEmissao() { return dataEmissao; }
    public void setDataEmissao(LocalDateTime dataEmissao) { this.dataEmissao = dataEmissao; }

    public static CertificadoDtoBuilder builder() { return new CertificadoDtoBuilder(); }

    public static class CertificadoDtoBuilder {
        private String usuarioNome;
        private String usuarioEmail;
        private String trilhaTitulo;
        private String codigoValidacao;
        private LocalDateTime dataEmissao;

        public CertificadoDtoBuilder usuarioNome(String usuarioNome) { this.usuarioNome = usuarioNome; return this; }
        public CertificadoDtoBuilder usuarioEmail(String usuarioEmail) { this.usuarioEmail = usuarioEmail; return this; }
        public CertificadoDtoBuilder trilhaTitulo(String trilhaTitulo) { this.trilhaTitulo = trilhaTitulo; return this; }
        public CertificadoDtoBuilder codigoValidacao(String codigoValidacao) { this.codigoValidacao = codigoValidacao; return this; }
        public CertificadoDtoBuilder dataEmissao(LocalDateTime dataEmissao) { this.dataEmissao = dataEmissao; return this; }

        public CertificadoDto build() {
            return new CertificadoDto(usuarioNome, usuarioEmail, trilhaTitulo, codigoValidacao, dataEmissao);
        }
    }
}
