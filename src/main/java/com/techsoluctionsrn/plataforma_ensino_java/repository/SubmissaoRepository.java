package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Submissao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubmissaoRepository extends JpaRepository<Submissao, Long> {
    List<Submissao> findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(Long usuarioId, Long exercicioId);
    List<Submissao> findByUsuarioIdOrderByDataSubmissaoDesc(Long usuarioId);
}
