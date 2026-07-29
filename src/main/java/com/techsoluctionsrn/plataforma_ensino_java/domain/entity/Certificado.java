package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "certificados")
public class Certificado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trilha_id", nullable = false)
    private Trilha trilha;

    @Column(name = "codigo_validacao", nullable = false, unique = true, length = 64)
    private String codigoValidacao;

    @Column(name = "data_emissao", nullable = false, updatable = false)
    private LocalDateTime dataEmissao;

    public Certificado() {}

    public Certificado(Long id, Usuario usuario, Trilha trilha, String codigoValidacao, LocalDateTime dataEmissao) {
        this.id = id;
        this.usuario = usuario;
        this.trilha = trilha;
        this.codigoValidacao = codigoValidacao;
        this.dataEmissao = dataEmissao;
    }

    @PrePersist
    public void prePersist() {
        if (dataEmissao == null) {
            dataEmissao = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Trilha getTrilha() { return trilha; }
    public void setTrilha(Trilha trilha) { this.trilha = trilha; }

    public String getCodigoValidacao() { return codigoValidacao; }
    public void setCodigoValidacao(String codigoValidacao) { this.codigoValidacao = codigoValidacao; }

    public LocalDateTime getDataEmissao() { return dataEmissao; }
    public void setDataEmissao(LocalDateTime dataEmissao) { this.dataEmissao = dataEmissao; }
}
