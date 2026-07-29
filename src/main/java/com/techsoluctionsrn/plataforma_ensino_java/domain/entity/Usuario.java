package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false)
    private String senha;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PapelUsuario papel;

    @Column(name = "criado_em", nullable = false, updatable = false)
    private LocalDateTime criadoEm;

    @Column(name = "xp_total")
    private int xpTotal = 0;

    public Usuario() {}

    public Usuario(Long id, String nome, String email, String senha, PapelUsuario papel, LocalDateTime criadoEm, int xpTotal) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.papel = papel;
        this.criadoEm = criadoEm;
        this.xpTotal = xpTotal;
    }

    @PrePersist
    public void prePersist() {
        if (criadoEm == null) {
            criadoEm = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public PapelUsuario getPapel() { return papel; }
    public void setPapel(PapelUsuario papel) { this.papel = papel; }

    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }

    public int getXpTotal() { return xpTotal; }
    public void setXpTotal(int xpTotal) { this.xpTotal = xpTotal; }
    public void adicionarXp(int xp) { this.xpTotal += xp; }

    public static UsuarioBuilder builder() { return new UsuarioBuilder(); }

    public static class UsuarioBuilder {
        private Long id;
        private String nome;
        private String email;
        private String senha;
        private PapelUsuario papel;
        private LocalDateTime criadoEm;

        public UsuarioBuilder id(Long id) { this.id = id; return this; }
        public UsuarioBuilder nome(String nome) { this.nome = nome; return this; }
        public UsuarioBuilder email(String email) { this.email = email; return this; }
        public UsuarioBuilder senha(String senha) { this.senha = senha; return this; }
        public UsuarioBuilder papel(PapelUsuario papel) { this.papel = papel; return this; }
        public UsuarioBuilder criadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; return this; }

        public Usuario build() {
            return new Usuario(id, nome, email, senha, papel, criadoEm, 0);
        }
    }
}
