package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "modulos")
public class Modulo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trilha_id", nullable = false)
    @JsonIgnore
    private Trilha trilha;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(columnDefinition = "TEXT")
    private String descricao;

    @Column(name = "conteudo_markdown", columnDefinition = "TEXT")
    private String conteudoMarkdown;

    @Column(nullable = false)
    private Integer ordem;

    @OneToMany(mappedBy = "modulo", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("ordem ASC")
    private List<Exercicio> exercicios = new ArrayList<>();

    public Modulo() {}

    public Modulo(Long id, Trilha trilha, String titulo, String descricao, String conteudoMarkdown, Integer ordem, List<Exercicio> exercicios) {
        this.id = id;
        this.trilha = trilha;
        this.titulo = titulo;
        this.descricao = descricao;
        this.conteudoMarkdown = conteudoMarkdown;
        this.ordem = ordem;
        if (exercicios != null) {
            this.exercicios = exercicios;
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Trilha getTrilha() { return trilha; }
    public void setTrilha(Trilha trilha) { this.trilha = trilha; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getConteudoMarkdown() { return conteudoMarkdown; }
    public void setConteudoMarkdown(String conteudoMarkdown) { this.conteudoMarkdown = conteudoMarkdown; }

    public Integer getOrdem() { return ordem; }
    public void setOrdem(Integer ordem) { this.ordem = ordem; }

    public List<Exercicio> getExercicios() { return exercicios; }
    public void setExercicios(List<Exercicio> exercicios) { this.exercicios = exercicios; }

    public static ModuloBuilder builder() { return new ModuloBuilder(); }

    public static class ModuloBuilder {
        private Long id;
        private Trilha trilha;
        private String titulo;
        private String descricao;
        private String conteudoMarkdown;
        private Integer ordem;
        private List<Exercicio> exercicios = new ArrayList<>();

        public ModuloBuilder id(Long id) { this.id = id; return this; }
        public ModuloBuilder trilha(Trilha trilha) { this.trilha = trilha; return this; }
        public ModuloBuilder titulo(String titulo) { this.titulo = titulo; return this; }
        public ModuloBuilder descricao(String descricao) { this.descricao = descricao; return this; }
        public ModuloBuilder conteudoMarkdown(String conteudoMarkdown) { this.conteudoMarkdown = conteudoMarkdown; return this; }
        public ModuloBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
        public ModuloBuilder exercicios(List<Exercicio> exercicios) { this.exercicios = exercicios; return this; }

        public Modulo build() {
            return new Modulo(id, trilha, titulo, descricao, conteudoMarkdown, ordem, exercicios);
        }
    }
}
