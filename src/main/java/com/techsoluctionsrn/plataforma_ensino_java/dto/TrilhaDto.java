package com.techsoluctionsrn.plataforma_ensino_java.dto;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.NivelTrilha;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;

import java.util.List;

public class TrilhaDto {

    public static class TrilhaResponseDto {
        private Long id;
        private String titulo;
        private String descricao;
        private NivelTrilha nivel;
        private Integer ordem;
        private List<ModuloResponseDto> modulos;
        private int totalModulos;
        private int modulosConcluidos;

        public TrilhaResponseDto() {}

        public TrilhaResponseDto(Long id, String titulo, String descricao, NivelTrilha nivel, Integer ordem, List<ModuloResponseDto> modulos, int totalModulos, int modulosConcluidos) {
            this.id = id;
            this.titulo = titulo;
            this.descricao = descricao;
            this.nivel = nivel;
            this.ordem = ordem;
            this.modulos = modulos;
            this.totalModulos = totalModulos;
            this.modulosConcluidos = modulosConcluidos;
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

        public List<ModuloResponseDto> getModulos() { return modulos; }
        public void setModulos(List<ModuloResponseDto> modulos) { this.modulos = modulos; }

        public int getTotalModulos() { return totalModulos; }
        public void setTotalModulos(int totalModulos) { this.totalModulos = totalModulos; }

        public int getModulosConcluidos() { return modulosConcluidos; }
        public void setModulosConcluidos(int modulosConcluidos) { this.modulosConcluidos = modulosConcluidos; }

        public static TrilhaResponseDtoBuilder builder() { return new TrilhaResponseDtoBuilder(); }

        public static class TrilhaResponseDtoBuilder {
            private Long id;
            private String titulo;
            private String descricao;
            private NivelTrilha nivel;
            private Integer ordem;
            private List<ModuloResponseDto> modulos;
            private int totalModulos;
            private int modulosConcluidos;

            public TrilhaResponseDtoBuilder id(Long id) { this.id = id; return this; }
            public TrilhaResponseDtoBuilder titulo(String titulo) { this.titulo = titulo; return this; }
            public TrilhaResponseDtoBuilder descricao(String descricao) { this.descricao = descricao; return this; }
            public TrilhaResponseDtoBuilder nivel(NivelTrilha nivel) { this.nivel = nivel; return this; }
            public TrilhaResponseDtoBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
            public TrilhaResponseDtoBuilder modulos(List<ModuloResponseDto> modulos) { this.modulos = modulos; return this; }
            public TrilhaResponseDtoBuilder totalModulos(int totalModulos) { this.totalModulos = totalModulos; return this; }
            public TrilhaResponseDtoBuilder modulosConcluidos(int modulosConcluidos) { this.modulosConcluidos = modulosConcluidos; return this; }

            public TrilhaResponseDto build() {
                return new TrilhaResponseDto(id, titulo, descricao, nivel, ordem, modulos, totalModulos, modulosConcluidos);
            }
        }
    }

    public static class ModuloResponseDto {
        private Long id;
        private Long trilhaId;
        private String titulo;
        private String descricao;
        private String conteudoMarkdown;
        private Integer ordem;
        private StatusProgresso statusProgresso;
        private boolean bloqueado;
        private List<ExercicioResponseDto> exercicios;

        public ModuloResponseDto() {}

        public ModuloResponseDto(Long id, Long trilhaId, String titulo, String descricao, String conteudoMarkdown, Integer ordem, StatusProgresso statusProgresso, boolean bloqueado, List<ExercicioResponseDto> exercicios) {
            this.id = id;
            this.trilhaId = trilhaId;
            this.titulo = titulo;
            this.descricao = descricao;
            this.conteudoMarkdown = conteudoMarkdown;
            this.ordem = ordem;
            this.statusProgresso = statusProgresso;
            this.bloqueado = bloqueado;
            this.exercicios = exercicios;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public Long getTrilhaId() { return trilhaId; }
        public void setTrilhaId(Long trilhaId) { this.trilhaId = trilhaId; }

        public String getTitulo() { return titulo; }
        public void setTitulo(String titulo) { this.titulo = titulo; }

        public String getDescricao() { return descricao; }
        public void setDescricao(String descricao) { this.descricao = descricao; }

        public String getConteudoMarkdown() { return conteudoMarkdown; }
        public void setConteudoMarkdown(String conteudoMarkdown) { this.conteudoMarkdown = conteudoMarkdown; }

        public Integer getOrdem() { return ordem; }
        public void setOrdem(Integer ordem) { this.ordem = ordem; }

        public StatusProgresso getStatusProgresso() { return statusProgresso; }
        public void setStatusProgresso(StatusProgresso statusProgresso) { this.statusProgresso = statusProgresso; }

        public boolean isBloqueado() { return bloqueado; }
        public void setBloqueado(boolean bloqueado) { this.bloqueado = bloqueado; }

        public List<ExercicioResponseDto> getExercicios() { return exercicios; }
        public void setExercicios(List<ExercicioResponseDto> exercicios) { this.exercicios = exercicios; }

        public static ModuloResponseDtoBuilder builder() { return new ModuloResponseDtoBuilder(); }

        public static class ModuloResponseDtoBuilder {
            private Long id;
            private Long trilhaId;
            private String titulo;
            private String descricao;
            private String conteudoMarkdown;
            private Integer ordem;
            private StatusProgresso statusProgresso;
            private boolean bloqueado;
            private List<ExercicioResponseDto> exercicios;

            public ModuloResponseDtoBuilder id(Long id) { this.id = id; return this; }
            public ModuloResponseDtoBuilder trilhaId(Long trilhaId) { this.trilhaId = trilhaId; return this; }
            public ModuloResponseDtoBuilder titulo(String titulo) { this.titulo = titulo; return this; }
            public ModuloResponseDtoBuilder descricao(String descricao) { this.descricao = descricao; return this; }
            public ModuloResponseDtoBuilder conteudoMarkdown(String conteudoMarkdown) { this.conteudoMarkdown = conteudoMarkdown; return this; }
            public ModuloResponseDtoBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
            public ModuloResponseDtoBuilder statusProgresso(StatusProgresso statusProgresso) { this.statusProgresso = statusProgresso; return this; }
            public ModuloResponseDtoBuilder bloqueado(boolean bloqueado) { this.bloqueado = bloqueado; return this; }
            public ModuloResponseDtoBuilder exercicios(List<ExercicioResponseDto> exercicios) { this.exercicios = exercicios; return this; }

            public ModuloResponseDto build() {
                return new ModuloResponseDto(id, trilhaId, titulo, descricao, conteudoMarkdown, ordem, statusProgresso, bloqueado, exercicios);
            }
        }
    }

    public static class ExercicioResponseDto {
        private Long id;
        private Long moduloId;
        private String titulo;
        private String enunciado;
        private String codigoTemplate;
        private Integer ordem;
        private boolean concluido;
        private String nivelDificuldade;
        private String dicaHint;
        private Integer pontosBase;

        public ExercicioResponseDto() {}

        public ExercicioResponseDto(Long id, Long moduloId, String titulo, String enunciado,
                                    String codigoTemplate, Integer ordem, boolean concluido,
                                    String nivelDificuldade, String dicaHint, Integer pontosBase) {
            this.id = id;
            this.moduloId = moduloId;
            this.titulo = titulo;
            this.enunciado = enunciado;
            this.codigoTemplate = codigoTemplate;
            this.ordem = ordem;
            this.concluido = concluido;
            this.nivelDificuldade = nivelDificuldade;
            this.dicaHint = dicaHint;
            this.pontosBase = pontosBase;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public Long getModuloId() { return moduloId; }
        public void setModuloId(Long moduloId) { this.moduloId = moduloId; }

        public String getTitulo() { return titulo; }
        public void setTitulo(String titulo) { this.titulo = titulo; }

        public String getEnunciado() { return enunciado; }
        public void setEnunciado(String enunciado) { this.enunciado = enunciado; }

        public String getCodigoTemplate() { return codigoTemplate; }
        public void setCodigoTemplate(String codigoTemplate) { this.codigoTemplate = codigoTemplate; }

        public Integer getOrdem() { return ordem; }
        public void setOrdem(Integer ordem) { this.ordem = ordem; }

        public boolean isConcluido() { return concluido; }
        public void setConcluido(boolean concluido) { this.concluido = concluido; }

        public String getNivelDificuldade() { return nivelDificuldade; }
        public void setNivelDificuldade(String nivelDificuldade) { this.nivelDificuldade = nivelDificuldade; }

        public String getDicaHint() { return dicaHint; }
        public void setDicaHint(String dicaHint) { this.dicaHint = dicaHint; }

        public Integer getPontosBase() { return pontosBase; }
        public void setPontosBase(Integer pontosBase) { this.pontosBase = pontosBase; }

        public static ExercicioResponseDtoBuilder builder() { return new ExercicioResponseDtoBuilder(); }

        public static class ExercicioResponseDtoBuilder {
            private Long id;
            private Long moduloId;
            private String titulo;
            private String enunciado;
            private String codigoTemplate;
            private Integer ordem;
            private boolean concluido;
            private String nivelDificuldade;
            private String dicaHint;
            private Integer pontosBase;

            public ExercicioResponseDtoBuilder id(Long id) { this.id = id; return this; }
            public ExercicioResponseDtoBuilder moduloId(Long moduloId) { this.moduloId = moduloId; return this; }
            public ExercicioResponseDtoBuilder titulo(String titulo) { this.titulo = titulo; return this; }
            public ExercicioResponseDtoBuilder enunciado(String enunciado) { this.enunciado = enunciado; return this; }
            public ExercicioResponseDtoBuilder codigoTemplate(String codigoTemplate) { this.codigoTemplate = codigoTemplate; return this; }
            public ExercicioResponseDtoBuilder ordem(Integer ordem) { this.ordem = ordem; return this; }
            public ExercicioResponseDtoBuilder concluido(boolean concluido) { this.concluido = concluido; return this; }
            public ExercicioResponseDtoBuilder nivelDificuldade(String nivelDificuldade) { this.nivelDificuldade = nivelDificuldade; return this; }
            public ExercicioResponseDtoBuilder dicaHint(String dicaHint) { this.dicaHint = dicaHint; return this; }
            public ExercicioResponseDtoBuilder pontosBase(Integer pontosBase) { this.pontosBase = pontosBase; return this; }

            public ExercicioResponseDto build() {
                return new ExercicioResponseDto(id, moduloId, titulo, enunciado, codigoTemplate, ordem, concluido,
                        nivelDificuldade, dicaHint, pontosBase);
            }
        }
    }
}
