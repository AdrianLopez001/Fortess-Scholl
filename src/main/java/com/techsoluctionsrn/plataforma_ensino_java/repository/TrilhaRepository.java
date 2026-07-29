package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Trilha;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrilhaRepository extends JpaRepository<Trilha, Long> {
    List<Trilha> findAllByOrderByOrdemAsc();
}
