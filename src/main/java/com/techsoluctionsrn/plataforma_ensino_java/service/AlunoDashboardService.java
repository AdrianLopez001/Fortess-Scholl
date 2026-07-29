package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.AtividadeDiaria;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import com.techsoluctionsrn.plataforma_ensino_java.dto.DashboardDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.AtividadeDiariaRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.ProgressoModuloRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.SubmissaoRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class AlunoDashboardService {

    private final UsuarioRepository usuarioRepository;
    private final AtividadeDiariaRepository atividadeDiariaRepository;
    private final ProgressoModuloRepository progressoModuloRepository;
    private final SubmissaoRepository submissaoRepository;

    public AlunoDashboardService(UsuarioRepository usuarioRepository,
                                  AtividadeDiariaRepository atividadeDiariaRepository,
                                  ProgressoModuloRepository progressoModuloRepository,
                                  SubmissaoRepository submissaoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.atividadeDiariaRepository = atividadeDiariaRepository;
        this.progressoModuloRepository = progressoModuloRepository;
        this.submissaoRepository = submissaoRepository;
    }

    @Transactional(readOnly = true)
    public DashboardDto.AlunoDashboard getDashboard(Usuario usuario) {
        // Calcular streak
        int streak = calcularStreak(usuario.getId());

        // Total de exercícios resolvidos com sucesso (únicos)
        List<?> submissoesSucesso = submissaoRepository.findAll().stream()
                .filter(s -> s.getUsuario().getId().equals(usuario.getId())
                        && s.getStatus() == StatusSubmissao.SUCESSO)
                .toList();
        // Unique exercicios
        long exerciciosUnicos = submissoesSucesso.stream()
                .map(s -> ((com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Submissao) s).getExercicio().getId())
                .distinct()
                .count();

        // Total de módulos concluídos
        long modulosConcluidos = progressoModuloRepository.findByUsuarioId(usuario.getId()).stream()
                .filter(p -> p.getStatus() == StatusProgresso.CONCLUIDO)
                .count();

        // Ranking
        List<Usuario> ranking = usuarioRepository.findAllOrderByXpTotalDesc();
        List<DashboardDto.RankingItem> rankingItems = new ArrayList<>();
        int posicaoUsuario = 1;
        for (int i = 0; i < ranking.size(); i++) {
            Usuario u = ranking.get(i);
            boolean isVoce = u.getId().equals(usuario.getId());
            if (isVoce) posicaoUsuario = i + 1;
            rankingItems.add(new DashboardDto.RankingItem(i + 1, u.getNome(), u.getXpTotal(), isVoce));
        }

        return DashboardDto.AlunoDashboard.builder()
                .nome(usuario.getNome())
                .email(usuario.getEmail())
                .xpTotal(usuario.getXpTotal())
                .posicaoRanking(posicaoUsuario)
                .streakAtual(streak)
                .totalExerciciosResolvidos((int) exerciciosUnicos)
                .totalModulosConcluidos((int) modulosConcluidos)
                .ranking(rankingItems)
                .build();
    }

    private int calcularStreak(Long usuarioId) {
        List<AtividadeDiaria> atividades = atividadeDiariaRepository.findByUsuarioIdOrderByDataDesc(usuarioId);
        if (atividades.isEmpty()) return 0;

        LocalDate hoje = LocalDate.now();
        int streak = 0;
        LocalDate dataEsperada = hoje;

        for (AtividadeDiaria atividade : atividades) {
            if (atividade.getData().equals(dataEsperada) && atividade.getExerciciosResolvidos() > 0) {
                streak++;
                dataEsperada = dataEsperada.minusDays(1);
            } else if (atividade.getData().isBefore(dataEsperada)) {
                // Gap na sequência, interrompe o streak
                break;
            }
        }

        return streak;
    }
}
