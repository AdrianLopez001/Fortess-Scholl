package com.techsoluctionsrn.plataforma_ensino_java.dto;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;

public class AdminProgressDto {
    private Long usuarioId;
    private String nome;
    private String email;
    private PapelUsuario papel;
    private int modulosConcluidos;
    private int totalModulos;
    private double percentualProgresso;
    private int exerciciosResolvidos;

    public AdminProgressDto() {}

    public AdminProgressDto(Long usuarioId, String nome, String email, PapelUsuario papel, int modulosConcluidos, int totalModulos, double percentualProgresso, int exerciciosResolvidos) {
        this.usuarioId = usuarioId;
        this.nome = nome;
        this.email = email;
        this.papel = papel;
        this.modulosConcluidos = modulosConcluidos;
        this.totalModulos = totalModulos;
        this.percentualProgresso = percentualProgresso;
        this.exerciciosResolvidos = exerciciosResolvidos;
    }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public PapelUsuario getPapel() { return papel; }
    public void setPapel(PapelUsuario papel) { this.papel = papel; }

    public int getModulosConcluidos() { return modulosConcluidos; }
    public void setModulosConcluidos(int modulosConcluidos) { this.modulosConcluidos = modulosConcluidos; }

    public int getTotalModulos() { return totalModulos; }
    public void setTotalModulos(int totalModulos) { this.totalModulos = totalModulos; }

    public double getPercentualProgresso() { return percentualProgresso; }
    public void setPercentualProgresso(double percentualProgresso) { this.percentualProgresso = percentualProgresso; }

    public int getExerciciosResolvidos() { return exerciciosResolvidos; }
    public void setExerciciosResolvidos(int exerciciosResolvidos) { this.exerciciosResolvidos = exerciciosResolvidos; }

    public static AdminProgressDtoBuilder builder() { return new AdminProgressDtoBuilder(); }

    public static class AdminProgressDtoBuilder {
        private Long usuarioId;
        private String nome;
        private String email;
        private PapelUsuario papel;
        private int modulosConcluidos;
        private int totalModulos;
        private double percentualProgresso;
        private int exerciciosResolvidos;

        public AdminProgressDtoBuilder usuarioId(Long usuarioId) { this.usuarioId = usuarioId; return this; }
        public AdminProgressDtoBuilder nome(String nome) { this.nome = nome; return this; }
        public AdminProgressDtoBuilder email(String email) { this.email = email; return this; }
        public AdminProgressDtoBuilder papel(PapelUsuario papel) { this.papel = papel; return this; }
        public AdminProgressDtoBuilder modulosConcluidos(int modulosConcluidos) { this.modulosConcluidos = modulosConcluidos; return this; }
        public AdminProgressDtoBuilder totalModulos(int totalModulos) { this.totalModulos = totalModulos; return this; }
        public AdminProgressDtoBuilder percentualProgresso(double percentualProgresso) { this.percentualProgresso = percentualProgresso; return this; }
        public AdminProgressDtoBuilder exerciciosResolvidos(int exerciciosResolvidos) { this.exerciciosResolvidos = exerciciosResolvidos; return this; }

        public AdminProgressDto build() {
            return new AdminProgressDto(usuarioId, nome, email, papel, modulosConcluidos, totalModulos, percentualProgresso, exerciciosResolvidos);
        }
    }
}
