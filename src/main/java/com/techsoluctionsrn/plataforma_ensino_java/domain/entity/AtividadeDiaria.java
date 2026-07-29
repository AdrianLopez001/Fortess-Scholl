package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "atividade_diaria")
public class AtividadeDiaria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(nullable = false)
    private LocalDate data;

    @Column(name = "exercicios_resolvidos")
    private int exerciciosResolvidos = 0;

    @Column(name = "pontos_ganhos")
    private int pontosGanhos = 0;

    public AtividadeDiaria() {}

    public AtividadeDiaria(Long id, Usuario usuario, LocalDate data, int exerciciosResolvidos, int pontosGanhos) {
        this.id = id;
        this.usuario = usuario;
        this.data = data;
        this.exerciciosResolvidos = exerciciosResolvidos;
        this.pontosGanhos = pontosGanhos;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public LocalDate getData() { return data; }
    public void setData(LocalDate data) { this.data = data; }

    public int getExerciciosResolvidos() { return exerciciosResolvidos; }
    public void setExerciciosResolvidos(int exerciciosResolvidos) { this.exerciciosResolvidos = exerciciosResolvidos; }

    public int getPontosGanhos() { return pontosGanhos; }
    public void setPontosGanhos(int pontosGanhos) { this.pontosGanhos = pontosGanhos; }
}
