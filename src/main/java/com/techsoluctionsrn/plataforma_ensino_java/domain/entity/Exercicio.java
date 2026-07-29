package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "exercicios")
public class Exercicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modulo_id", nullable = false)
    @JsonIgnore
    private Modulo modulo;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String enunciado;

    @Column(name = "codigo_template", columnDefinition = "TEXT")
    private String codigoTemplate;

    @Column(name = "testes_junit_code", columnDefinition = "TEXT", nullable = false)
    private String testesJunitCode;

    @Column(nullable = false)
    private Integer ordem;

    @Column(name = "dica_hint", columnDefinition = "TEXT")
    private String dicaHint;

    @Column(name = "nivel_dificuldade", length = 10)
    private String nivelDificuldade = "MEDIUM";

    @Column(name = "pontos_base")
    private Integer pontosBase = 100;

    public Exercicio() {}

    public Exercicio(Long id, Modulo modulo, String titulo, String enunciado, String codigoTemplate, String testesJunitCode, Integer ordem, String dicaHint, String nivelDificuldade, Integer pontosBase) {
        this.id = id;
        this.modulo = modulo;
        this.titulo = titulo;
        this.enunciado = enunciado;
        this.codigoTemplate = codigoTemplate;
        this.testesJunitCode = testesJunitCode;
        this.ordem = ordem;
        this.dicaHint = dicaHint;
        this.nivelDificuldade = nivelDificuldade;
        this.pontosBase = pontosBase;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Modulo getModulo() { return modulo; }
    public void setModulo(Modulo modulo) { this.modulo = modulo; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getEnunciado() { return enunciado; }
    public void setEnunciado(String enunciado) { this.enunciado = enunciado; }

    public String getCodigoTemplate() { return codigoTemplate; }
    public void setCodigoTemplate(String codigoTemplate) { this.codigoTemplate = codigoTemplate; }

    public String getTestesJunitCode() { return testesJunitCode; }
    public void setTestesJunitCode(String testesJunitCode) { this.testesJunitCode = testesJunitCode; }

    public Integer getOrdem() { return ordem; }
    public void setOrdem(Integer ordem) { this.ordem = ordem; }

    public String getDicaHint() { return dicaHint; }
    public void setDicaHint(String dicaHint) { this.dicaHint = dicaHint; }

    public String getNivelDificuldade() { return nivelDificuldade; }
    public void setNivelDificuldade(String nivelDificuldade) { this.nivelDificuldade = nivelDificuldade; }

    public Integer getPontosBase() { return pontosBase; }
    public void setPontosBase(Integer pontosBase) { this.pontosBase = pontosBase; }

    public static ExercicioBuilder builder() { return new ExercicioBuilder(); }

    public static class ExercicioBuilder {
        private Long id;
        private Modulo modulo;
        private String titulo;
        private String enunciado;
        private String codigoTemplate;
        private String testesJunitCode;
        private Integer ordem;
        private String dicaHint;
        private String nivelDificuldade = "MEDIUM";
        private Integer pontosBase = 100;

        public ExercicioBuilder id(Long id) { this.id = id; return this; }
        public ExercicioBuilder modulo(Modulo modulo) { this.modulo = modulo; return this; }
        public ExercicioBuilder titulo(String titulo) { this.titulo = titulo; return this; }
        public ExercicioBuilder enunciado(String enunciado) { this.enunciado = enunciado; return this; }
        public ExercicioBuilder codigoTemplate(String codigoTemplate) { this.codigoTemplate = codigoTemplate; return this; }
        public ExercicioBuilder testesJunitCode(String testesJunitCode) { this.testesJunitCode = testesJunitCode; return this; }
        public ExercicioBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
        public ExercicioBuilder dicaHint(String dicaHint) { this.dicaHint = dicaHint; return this; }
        public ExercicioBuilder nivelDificuldade(String nivelDificuldade) { this.nivelDificuldade = nivelDificuldade; return this; }
        public ExercicioBuilder pontosBase(Integer pontosBase) { this.pontosBase = pontosBase; return this; }

        public Exercicio build() {
            return new Exercicio(id, modulo, titulo, enunciado, codigoTemplate, testesJunitCode, ordem, dicaHint, nivelDificuldade, pontosBase);
        }
    }
}

