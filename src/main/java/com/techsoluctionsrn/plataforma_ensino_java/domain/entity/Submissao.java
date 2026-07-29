package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "submissoes")
public class Submissao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercicio_id", nullable = false)
    private Exercicio exercicio;

    @Column(name = "codigo_enviado", columnDefinition = "TEXT", nullable = false)
    private String codigoEnviado;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private StatusSubmissao status;

    @Column(name = "detalhes_erro", columnDefinition = "TEXT")
    private String detalhesErro;

    @Column(name = "data_submissao", nullable = false, updatable = false)
    private LocalDateTime dataSubmissao;

    @Column(name = "pontos_obtidos")
    private int pontosObtidos = 0;

    @Column(name = "tentativas")
    private int tentativas = 1;

    public Submissao() {}

    public Submissao(Long id, Usuario usuario, Exercicio exercicio, String codigoEnviado, StatusSubmissao status, String detalhesErro, LocalDateTime dataSubmissao) {
        this.id = id;
        this.usuario = usuario;
        this.exercicio = exercicio;
        this.codigoEnviado = codigoEnviado;
        this.status = status;
        this.detalhesErro = detalhesErro;
        this.dataSubmissao = dataSubmissao;
    }

    @PrePersist
    public void prePersist() {
        if (dataSubmissao == null) {
            dataSubmissao = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Exercicio getExercicio() { return exercicio; }
    public void setExercicio(Exercicio exercicio) { this.exercicio = exercicio; }

    public String getCodigoEnviado() { return codigoEnviado; }
    public void setCodigoEnviado(String codigoEnviado) { this.codigoEnviado = codigoEnviado; }

    public StatusSubmissao getStatus() { return status; }
    public void setStatus(StatusSubmissao status) { this.status = status; }

    public String getDetalhesErro() { return detalhesErro; }
    public void setDetalhesErro(String detalhesErro) { this.detalhesErro = detalhesErro; }

    public LocalDateTime getDataSubmissao() { return dataSubmissao; }
    public void setDataSubmissao(LocalDateTime dataSubmissao) { this.dataSubmissao = dataSubmissao; }

    public int getPontosObtidos() { return pontosObtidos; }
    public void setPontosObtidos(int pontosObtidos) { this.pontosObtidos = pontosObtidos; }

    public int getTentativas() { return tentativas; }
    public void setTentativas(int tentativas) { this.tentativas = tentativas; }

    public static SubmissaoBuilder builder() { return new SubmissaoBuilder(); }

    public static class SubmissaoBuilder {
        private Long id;
        private Usuario usuario;
        private Exercicio exercicio;
        private String codigoEnviado;
        private StatusSubmissao status;
        private String detalhesErro;
        private LocalDateTime dataSubmissao;

        public SubmissaoBuilder id(Long id) { this.id = id; return this; }
        public SubmissaoBuilder usuario(Usuario usuario) { this.usuario = usuario; return this; }
        public SubmissaoBuilder exercicio(Exercicio exercicio) { this.exercicio = exercicio; return this; }
        public SubmissaoBuilder codigoEnviado(String codigoEnviado) { this.codigoEnviado = codigoEnviado; return this; }
        public SubmissaoBuilder status(StatusSubmissao status) { this.status = status; return this; }
        public SubmissaoBuilder detalhesErro(String detalhesErro) { this.detalhesErro = detalhesErro; return this; }
        public SubmissaoBuilder dataSubmissao(LocalDateTime dataSubmissao) { this.dataSubmissao = dataSubmissao; return this; }

        public Submissao build() {
            return new Submissao(id, usuario, exercicio, codigoEnviado, status, detalhesErro, dataSubmissao);
        }
    }
}
