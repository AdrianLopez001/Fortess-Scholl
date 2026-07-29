package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.ProgressoModulo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProgressoModuloRepository extends JpaRepository<ProgressoModulo, Long> {
    Optional<ProgressoModulo> findByUsuarioIdAndModuloId(Long usuarioId, Long moduloId);
    List<ProgressoModulo> findByUsuarioId(Long usuarioId);
}
