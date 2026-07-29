package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "quizzes")
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modulo_id", nullable = false)
    @JsonIgnore
    private Modulo modulo;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String pergunta;

    @Column(nullable = false)
    private Integer ordem;

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<QuizOpcao> opcoes = new ArrayList<>();

    public Quiz() {}

    public Quiz(Long id, Modulo modulo, String pergunta, Integer ordem, List<QuizOpcao> opcoes) {
        this.id = id;
        this.modulo = modulo;
        this.pergunta = pergunta;
        this.ordem = ordem;
        if (opcoes != null) this.opcoes = opcoes;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Modulo getModulo() { return modulo; }
    public void setModulo(Modulo modulo) { this.modulo = modulo; }

    public String getPergunta() { return pergunta; }
    public void setPergunta(String pergunta) { this.pergunta = pergunta; }

    public Integer getOrdem() { return ordem; }
    public void setOrdem(Integer ordem) { this.ordem = ordem; }

    public List<QuizOpcao> getOpcoes() { return opcoes; }
    public void setOpcoes(List<QuizOpcao> opcoes) { this.opcoes = opcoes; }
}
