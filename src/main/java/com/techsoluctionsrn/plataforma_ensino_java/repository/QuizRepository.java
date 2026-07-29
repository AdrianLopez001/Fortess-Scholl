package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findByModuloIdOrderByOrdemAsc(Long moduloId);
}
