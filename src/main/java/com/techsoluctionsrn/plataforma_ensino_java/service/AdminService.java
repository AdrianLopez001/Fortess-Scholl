package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.ProgressoModulo;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Submissao;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import com.techsoluctionsrn.plataforma_ensino_java.dto.AdminProgressDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.ModuloRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.ProgressoModuloRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.SubmissaoRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class AdminService {

    private final UsuarioRepository usuarioRepository;
    private final ModuloRepository moduloRepository;
    private final ProgressoModuloRepository progressoModuloRepository;
    private final SubmissaoRepository submissaoRepository;

    public AdminService(UsuarioRepository usuarioRepository, ModuloRepository moduloRepository, ProgressoModuloRepository progressoModuloRepository, SubmissaoRepository submissaoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.moduloRepository = moduloRepository;
        this.progressoModuloRepository = progressoModuloRepository;
        this.submissaoRepository = submissaoRepository;
    }

    @Transactional(readOnly = true)
    public List<AdminProgressDto> getProgressoGeralEquipe() {
        List<Usuario> usuarios = usuarioRepository.findAll();
        int totalModulos = (int) moduloRepository.count();

        List<AdminProgressDto> resultado = new ArrayList<>();
        for (Usuario u : usuarios) {
            List<ProgressoModulo> progressos = progressoModuloRepository.findByUsuarioId(u.getId());
            int concluidos = 0;
            for (ProgressoModulo p : progressos) {
                if (p.getStatus() == StatusProgresso.CONCLUIDO) {
                    concluidos++;
                }
            }

            List<Submissao> submissoes = submissaoRepository.findByUsuarioIdOrderByDataSubmissaoDesc(u.getId());
            Set<Long> exerciciosResolvidosSet = new HashSet<>();
            for (Submissao s : submissoes) {
                if (s.getStatus() == StatusSubmissao.SUCESSO) {
                    exerciciosResolvidosSet.add(s.getExercicio().getId());
                }
            }

            double percentual = totalModulos > 0 ? (concluidos * 100.0) / totalModulos : 0.0;

            resultado.add(AdminProgressDto.builder()
                    .usuarioId(u.getId())
                    .nome(u.getNome())
                    .email(u.getEmail())
                    .papel(u.getPapel())
                    .modulosConcluidos(concluidos)
                    .totalModulos(totalModulos)
                    .percentualProgresso(Math.round(percentual * 10.0) / 10.0)
                    .exerciciosResolvidos(exerciciosResolvidosSet.size())
                    .build());
        }

        return resultado;
    }
}
