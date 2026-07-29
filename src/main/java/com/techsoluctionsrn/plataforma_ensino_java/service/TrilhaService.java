package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.*;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import com.techsoluctionsrn.plataforma_ensino_java.dto.TrilhaDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class TrilhaService {

    private final TrilhaRepository trilhaRepository;
    private final ModuloRepository moduloRepository;
    private final ExercicioRepository exercicioRepository;
    private final ProgressoModuloRepository progressoModuloRepository;
    private final SubmissaoRepository submissaoRepository;

    public TrilhaService(TrilhaRepository trilhaRepository, ModuloRepository moduloRepository, ExercicioRepository exercicioRepository, ProgressoModuloRepository progressoModuloRepository, SubmissaoRepository submissaoRepository) {
        this.trilhaRepository = trilhaRepository;
        this.moduloRepository = moduloRepository;
        this.exercicioRepository = exercicioRepository;
        this.progressoModuloRepository = progressoModuloRepository;
        this.submissaoRepository = submissaoRepository;
    }

    @Transactional(readOnly = true)
    public List<TrilhaDto.TrilhaResponseDto> getTrilhasComProgresso(Usuario usuario) {
        List<Trilha> trilhas = trilhaRepository.findAllByOrderByOrdemAsc();
        List<ProgressoModulo> progressos = progressoModuloRepository.findByUsuarioId(usuario.getId());

        Map<Long, StatusProgresso> statusMap = new HashMap<>();
        for (ProgressoModulo p : progressos) {
            statusMap.put(p.getModulo().getId(), p.getStatus());
        }

        List<TrilhaDto.TrilhaResponseDto> resultado = new ArrayList<>();
        for (Trilha trilha : trilhas) {
            List<TrilhaDto.ModuloResponseDto> modulosDto = new ArrayList<>();
            boolean moduloAnteriorConcluido = true; // Primeiro módulo sempre liberado

            for (Modulo modulo : trilha.getModulos()) {
                StatusProgresso status = statusMap.getOrDefault(modulo.getId(), StatusProgresso.NAO_INICIADO);
                boolean bloqueado = usuario.getPapel() != com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario.ADMIN
                        && modulo.getOrdem() > 1
                        && !moduloAnteriorConcluido;

                modulosDto.add(TrilhaDto.ModuloResponseDto.builder()
                        .id(modulo.getId())
                        .trilhaId(trilha.getId())
                        .titulo(modulo.getTitulo())
                        .descricao(modulo.getDescricao())
                        .ordem(modulo.getOrdem())
                        .statusProgresso(status)
                        .bloqueado(bloqueado)
                        .build());

                moduloAnteriorConcluido = (status == StatusProgresso.CONCLUIDO);
            }

            int totalModulos = modulosDto.size();
            int modulosConcluidos = 0;
            for (TrilhaDto.ModuloResponseDto m : modulosDto) {
                if (m.getStatusProgresso() == StatusProgresso.CONCLUIDO) {
                    modulosConcluidos++;
                }
            }

            resultado.add(TrilhaDto.TrilhaResponseDto.builder()
                    .id(trilha.getId())
                    .titulo(trilha.getTitulo())
                    .descricao(trilha.getDescricao())
                    .nivel(trilha.getNivel())
                    .ordem(trilha.getOrdem())
                    .modulos(modulosDto)
                    .totalModulos(totalModulos)
                    .modulosConcluidos(modulosConcluidos)
                    .build());
        }

        return resultado;
    }

    @Transactional(readOnly = true)
    public TrilhaDto.ModuloResponseDto getModuloDetalhado(Long moduloId, Usuario usuario) {
        Modulo modulo = moduloRepository.findById(moduloId)
                .orElseThrow(() -> new IllegalArgumentException("Módulo não encontrado com o ID: " + moduloId));

        ProgressoModulo progresso = progressoModuloRepository.findByUsuarioIdAndModuloId(usuario.getId(), moduloId)
                .orElse(null);
        StatusProgresso status = progresso != null ? progresso.getStatus() : StatusProgresso.NAO_INICIADO;

        List<TrilhaDto.ExercicioResponseDto> exerciciosDto = new ArrayList<>();
        for (Exercicio ex : modulo.getExercicios()) {
            List<Submissao> submissoes = submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(usuario.getId(), ex.getId());
            boolean concluido = false;
            for (Submissao s : submissoes) {
                if (s.getStatus() == StatusSubmissao.SUCESSO) {
                    concluido = true;
                    break;
                }
            }

            exerciciosDto.add(TrilhaDto.ExercicioResponseDto.builder()
                    .id(ex.getId())
                    .moduloId(moduloId)
                    .titulo(ex.getTitulo())
                    .enunciado(ex.getEnunciado())
                    .codigoTemplate(ex.getCodigoTemplate())
                    .ordem(ex.getOrdem())
                    .concluido(concluido)
                    .nivelDificuldade(ex.getNivelDificuldade())
                    .dicaHint(ex.getDicaHint())
                    .pontosBase(ex.getPontosBase() != null ? ex.getPontosBase() : 100)
                    .build());
        }

        return TrilhaDto.ModuloResponseDto.builder()
                .id(modulo.getId())
                .trilhaId(modulo.getTrilha().getId())
                .titulo(modulo.getTitulo())
                .descricao(modulo.getDescricao())
                .conteudoMarkdown(modulo.getConteudoMarkdown())
                .ordem(modulo.getOrdem())
                .statusProgresso(status)
                .exercicios(exerciciosDto)
                .build();
    }
}
