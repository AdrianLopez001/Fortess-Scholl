package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.*;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import com.techsoluctionsrn.plataforma_ensino_java.dto.ExecutionResultDto;
import com.techsoluctionsrn.plataforma_ensino_java.dto.SubmissaoDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class SubmissaoService {

    private final ExercicioRepository exercicioRepository;
    private final SubmissaoRepository submissaoRepository;
    private final ProgressoModuloRepository progressoModuloRepository;
    private final SandboxRunner exerciseRunnerService;
    private final UsuarioRepository usuarioRepository;
    private final AtividadeDiariaRepository atividadeDiariaRepository;

    public SubmissaoService(ExercicioRepository exercicioRepository,
                            SubmissaoRepository submissaoRepository,
                            ProgressoModuloRepository progressoModuloRepository,
                            SandboxRunner exerciseRunnerService,
                            UsuarioRepository usuarioRepository,
                            AtividadeDiariaRepository atividadeDiariaRepository) {
        this.exercicioRepository = exercicioRepository;
        this.submissaoRepository = submissaoRepository;
        this.progressoModuloRepository = progressoModuloRepository;
        this.exerciseRunnerService = exerciseRunnerService;
        this.usuarioRepository = usuarioRepository;
        this.atividadeDiariaRepository = atividadeDiariaRepository;
    }

    @Transactional
    public SubmissaoDto.SubmissaoResponse submeterExercicio(SubmissaoDto.SubmissaoRequest request, Usuario usuario) {
        Exercicio exercicio = exercicioRepository.findById(request.getExercicioId())
                .orElseThrow(() -> new IllegalArgumentException("Exercício não encontrado com o ID: " + request.getExercicioId()));

        // Contar tentativas anteriores para cálculo de XP e dicas
        List<Submissao> tentativasAnteriores = submissaoRepository
                .findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(usuario.getId(), exercicio.getId());
        int numeroTentativa = tentativasAnteriores.size() + 1;

        // Executar na sandbox JUnit
        ExecutionResultDto result = exerciseRunnerService.executeSubmission(
                request.getCodigoEnviado(),
                exercicio.getTestesJunitCode()
        );

        // Calcular XP ganho com base na tentativa
        int pontosGanhos = 0;
        if (result.getStatus() == StatusSubmissao.SUCESSO) {
            int pontosBase = exercicio.getPontosBase() != null ? exercicio.getPontosBase() : 100;
            if (numeroTentativa == 1) pontosGanhos = pontosBase;           // 100% na 1ª
            else if (numeroTentativa == 2) pontosGanhos = (int)(pontosBase * 0.7); // 70% na 2ª
            else pontosGanhos = (int)(pontosBase * 0.5);                   // 50% depois
        }

        Submissao submissao = Submissao.builder()
                .usuario(usuario)
                .exercicio(exercicio)
                .codigoEnviado(request.getCodigoEnviado())
                .status(result.getStatus())
                .detalhesErro(result.getErrorMessage() != null ? result.getErrorMessage() : result.getOutput())
                .build();
        submissao.setPontosObtidos(pontosGanhos);
        submissao.setTentativas(numeroTentativa);

        submissaoRepository.save(submissao);

        // Atualizar XP do usuário e atividade diária se resolveu com sucesso
        if (result.getStatus() == StatusSubmissao.SUCESSO && pontosGanhos > 0) {
            // Somente soma XP se for a PRIMEIRA vez que resolve com sucesso
            boolean jaResolveuAntes = tentativasAnteriores.stream()
                    .anyMatch(s -> s.getStatus() == StatusSubmissao.SUCESSO);
            if (!jaResolveuAntes) {
                usuario.adicionarXp(pontosGanhos);
                usuarioRepository.save(usuario);
                registrarAtividadeDiaria(usuario, pontosGanhos);
            }
        }

        // Atualizar progresso do módulo (regra: 70% dos exercícios concluídos)
        boolean moduloConcluido = atualizarProgresso(usuario, exercicio.getModulo());

        // Verificar se deve mostrar dica (após 2 tentativas falhas)
        String dica = null;
        if (result.getStatus() != StatusSubmissao.SUCESSO && numeroTentativa >= 2 && exercicio.getDicaHint() != null) {
            dica = exercicio.getDicaHint();
        }

        // Calcular nota atual do módulo
        double percentualModulo = calcularPercentualModulo(usuario, exercicio.getModulo());

        return SubmissaoDto.SubmissaoResponse.builder()
                .id(submissao.getId())
                .exercicioId(exercicio.getId())
                .status(result.getStatus())
                .detalhesErro(result.getErrorMessage())
                .output(result.getOutput())
                .dataSubmissao(submissao.getDataSubmissao())
                .moduloConcluido(moduloConcluido)
                .pontosGanhos(pontosGanhos)
                .xpTotalUsuario(usuario.getXpTotal())
                .tentativa(numeroTentativa)
                .dica(dica)
                .percentualModulo(percentualModulo)
                .nivelDificuldade(exercicio.getNivelDificuldade())
                .build();
    }

    @Transactional(readOnly = true)
    public List<SubmissaoDto.SubmissaoResponse> getHistoricoSubmissoes(Long exercicioId, Usuario usuario) {
        List<Submissao> submissoes = submissaoRepository
                .findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(usuario.getId(), exercicioId);
        return submissoes.stream().map(s -> SubmissaoDto.SubmissaoResponse.builder()
                .id(s.getId())
                .exercicioId(s.getExercicio().getId())
                .status(s.getStatus())
                .detalhesErro(s.getDetalhesErro())
                .output(s.getDetalhesErro()) // output armazena o texto completo do resultado
                .dataSubmissao(s.getDataSubmissao())
                .pontosGanhos(s.getPontosObtidos())
                .tentativa(s.getTentativas())
                .build()
        ).toList();
    }

    private void registrarAtividadeDiaria(Usuario usuario, int pontos) {
        LocalDate hoje = LocalDate.now();
        AtividadeDiaria atividade = atividadeDiariaRepository
                .findByUsuarioIdAndData(usuario.getId(), hoje)
                .orElseGet(() -> {
                    AtividadeDiaria nova = new AtividadeDiaria(null, usuario, hoje, 0, 0);
                    return nova;
                });
        atividade.setExerciciosResolvidos(atividade.getExerciciosResolvidos() + 1);
        atividade.setPontosGanhos(atividade.getPontosGanhos() + pontos);
        atividadeDiariaRepository.save(atividade);
    }

    private double calcularPercentualModulo(Usuario usuario, Modulo modulo) {
        List<Exercicio> exerciciosDoModulo = exercicioRepository.findByModuloIdOrderByOrdemAsc(modulo.getId());
        if (exerciciosDoModulo.isEmpty()) return 0.0;

        long concluidos = exerciciosDoModulo.stream()
                .filter(ex -> {
                    List<Submissao> subs = submissaoRepository
                            .findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(usuario.getId(), ex.getId());
                    return subs.stream().anyMatch(s -> s.getStatus() == StatusSubmissao.SUCESSO);
                }).count();

        return (double) concluidos / exerciciosDoModulo.size() * 100.0;
    }

    private boolean atualizarProgresso(Usuario usuario, Modulo modulo) {
        ProgressoModulo progresso = progressoModuloRepository
                .findByUsuarioIdAndModuloId(usuario.getId(), modulo.getId())
                .orElseGet(() -> ProgressoModulo.builder()
                        .usuario(usuario)
                        .modulo(modulo)
                        .status(StatusProgresso.EM_ANDAMENTO)
                        .build());

        List<Exercicio> exerciciosDoModulo = exercicioRepository.findByModuloIdOrderByOrdemAsc(modulo.getId());

        if (exerciciosDoModulo.isEmpty()) return false;

        long totalExercicios = exerciciosDoModulo.size();
        long concluidos = 0;
        for (Exercicio ex : exerciciosDoModulo) {
            List<Submissao> submissoes = submissaoRepository
                    .findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(usuario.getId(), ex.getId());
            for (Submissao s : submissoes) {
                if (s.getStatus() == StatusSubmissao.SUCESSO) {
                    concluidos++;
                    break;
                }
            }
        }

        // REGRA PROFISSIONAL: Mínimo 70% dos exercícios concluídos para avançar
        double percentual = (double) concluidos / totalExercicios * 100.0;
        if (percentual >= 70.0) {
            progresso.setStatus(StatusProgresso.CONCLUIDO);
            progresso.setDataConclusao(LocalDateTime.now());
            progressoModuloRepository.save(progresso);
            return true;
        } else {
            if (progresso.getStatus() == StatusProgresso.NAO_INICIADO) {
                progresso.setStatus(StatusProgresso.EM_ANDAMENTO);
            }
            progressoModuloRepository.save(progresso);
            return false;
        }
    }
}
