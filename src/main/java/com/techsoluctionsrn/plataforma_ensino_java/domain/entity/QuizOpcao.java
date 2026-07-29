package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "quiz_opcoes")
public class QuizOpcao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    @JsonIgnore
    private Quiz quiz;

    @Column(name = "texto_opcao", columnDefinition = "TEXT", nullable = false)
    private String textoOpcao;

    @Column(name = "is_correta", nullable = false)
    private boolean correta;

    public QuizOpcao() {}

    public QuizOpcao(Long id, Quiz quiz, String textoOpcao, boolean correta) {
        this.id = id;
        this.quiz = quiz;
        this.textoOpcao = textoOpcao;
        this.correta = correta;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Quiz getQuiz() { return quiz; }
    public void setQuiz(Quiz quiz) { this.quiz = quiz; }

    public String getTextoOpcao() { return textoOpcao; }
    public void setTextoOpcao(String textoOpcao) { this.textoOpcao = textoOpcao; }

    public boolean isCorreta() { return correta; }
    public void setCorreta(boolean correta) { this.correta = correta; }
}
