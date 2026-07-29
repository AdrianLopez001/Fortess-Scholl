package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "progresso_modulos", uniqueConstraints = {
    @UniqueConstraint(name = "uk_usuario_modulo", columnNames = {"usuario_id", "modulo_id"})
})
public class ProgressoModulo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modulo_id", nullable = false)
    private Modulo modulo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private StatusProgresso status;

    @Column(name = "data_conclusao")
    private LocalDateTime dataConclusao;

    public ProgressoModulo() {}

    public ProgressoModulo(Long id, Usuario usuario, Modulo modulo, StatusProgresso status, LocalDateTime dataConclusao) {
        this.id = id;
        this.usuario = usuario;
        this.modulo = modulo;
        this.status = status;
        this.dataConclusao = dataConclusao;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Modulo getModulo() { return modulo; }
    public void setModulo(Modulo modulo) { this.modulo = modulo; }

    public StatusProgresso getStatus() { return status; }
    public void setStatus(StatusProgresso status) { this.status = status; }

    public LocalDateTime getDataConclusao() { return dataConclusao; }
    public void setDataConclusao(LocalDateTime dataConclusao) { this.dataConclusao = dataConclusao; }

    public static ProgressoModuloBuilder builder() { return new ProgressoModuloBuilder(); }

    public static class ProgressoModuloBuilder {
        private Long id;
        private Usuario usuario;
        private Modulo modulo;
        private StatusProgresso status;
        private LocalDateTime dataConclusao;

        public ProgressoModuloBuilder id(Long id) { this.id = id; return this; }
        public ProgressoModuloBuilder usuario(Usuario usuario) { this.usuario = usuario; return this; }
        public ProgressoModuloBuilder modulo(Modulo modulo) { this.modulo = modulo; return this; }
        public ProgressoModuloBuilder status(StatusProgresso status) { this.status = status; return this; }
        public ProgressoModuloBuilder dataConclusao(LocalDateTime dataConclusao) { this.dataConclusao = dataConclusao; return this; }

        public ProgressoModulo build() {
            return new ProgressoModulo(id, usuario, modulo, status, dataConclusao);
        }
    }
}
