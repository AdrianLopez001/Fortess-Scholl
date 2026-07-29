package com.techsoluctionsrn.plataforma_ensino_java.domain.entity;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.NivelTrilha;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "trilhas")
public class Trilha {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(columnDefinition = "TEXT")
    private String descricao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private NivelTrilha nivel;

    @Column(nullable = false)
    private Integer ordem;

    @OneToMany(mappedBy = "trilha", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("ordem ASC")
    private List<Modulo> modulos = new ArrayList<>();

    public Trilha() {}

    public Trilha(Long id, String titulo, String descricao, NivelTrilha nivel, Integer ordem, List<Modulo> modulos) {
        this.id = id;
        this.titulo = titulo;
        this.descricao = descricao;
        this.nivel = nivel;
        this.ordem = ordem;
        if (modulos != null) {
            this.modulos = modulos;
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public NivelTrilha getNivel() { return nivel; }
    public void setNivel(NivelTrilha nivel) { this.nivel = nivel; }

    public Integer getOrdem() { return ordem; }
    public void setOrdem(Integer ordem) { this.ordem = ordem; }

    public List<Modulo> getModulos() { return modulos; }
    public void setModulos(List<Modulo> modulos) { this.modulos = modulos; }

    public static TrilhaBuilder builder() { return new TrilhaBuilder(); }

    public static class TrilhaBuilder {
        private Long id;
        private String titulo;
        private String descricao;
        private NivelTrilha nivel;
        private Integer ordem;
        private List<Modulo> modulos = new ArrayList<>();

        public TrilhaBuilder id(Long id) { this.id = id; return this; }
        public TrilhaBuilder titulo(String titulo) { this.titulo = titulo; return this; }
        public TrilhaBuilder descricao(String descricao) { this.descricao = descricao; return this; }
        public TrilhaBuilder nivel(NivelTrilha nivel) { this.nivel = nivel; return this; }
        public TrilhaBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
        public TrilhaBuilder modulos(List<Modulo> modulos) { this.modulos = modulos; return this; }

        public Trilha build() {
            return new Trilha(id, titulo, descricao, nivel, ordem, modulos);
        }
    }
}
