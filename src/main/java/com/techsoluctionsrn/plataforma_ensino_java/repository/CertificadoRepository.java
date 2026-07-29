package com.techsoluctionsrn.plataforma_ensino_java.repository;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Certificado;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CertificadoRepository extends JpaRepository<Certificado, Long> {
    Optional<Certificado> findByUsuarioIdAndTrilhaId(Long usuarioId, Long trilhaId);
    Optional<Certificado> findByCodigoValidacao(String codigoValidacao);
}
