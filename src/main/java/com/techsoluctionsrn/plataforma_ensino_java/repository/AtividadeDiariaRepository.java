package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.AtividadeDiaria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AtividadeDiariaRepository extends JpaRepository<AtividadeDiaria, Long> {
    Optional<AtividadeDiaria> findByUsuarioIdAndData(Long usuarioId, LocalDate data);
    List<AtividadeDiaria> findByUsuarioIdOrderByDataDesc(Long usuarioId);
}
