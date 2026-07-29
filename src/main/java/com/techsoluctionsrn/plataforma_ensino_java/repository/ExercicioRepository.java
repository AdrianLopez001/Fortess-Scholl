package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Exercicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExercicioRepository extends JpaRepository<Exercicio, Long> {
    List<Exercicio> findByModuloIdOrderByOrdemAsc(Long moduloId);
}
