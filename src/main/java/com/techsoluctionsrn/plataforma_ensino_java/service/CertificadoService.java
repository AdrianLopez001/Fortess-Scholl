package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Certificado;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Modulo;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.ProgressoModulo;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Trilha;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.dto.CertificadoDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.CertificadoRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.ProgressoModuloRepository;
import com.techsoluctionsrn.plataforma_ensino_java.repository.TrilhaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class CertificadoService {

    private final CertificadoRepository certificadoRepository;
    private final TrilhaRepository trilhaRepository;
    private final ProgressoModuloRepository progressoModuloRepository;

    public CertificadoService(CertificadoRepository certificadoRepository, TrilhaRepository trilhaRepository, ProgressoModuloRepository progressoModuloRepository) {
        this.certificadoRepository = certificadoRepository;
        this.trilhaRepository = trilhaRepository;
        this.progressoModuloRepository = progressoModuloRepository;
    }

    @Transactional
    public CertificadoDto obterOuEmitirCertificado(Long trilhaId, Usuario usuario) {
        Trilha trilha = trilhaRepository.findById(trilhaId)
                .orElseThrow(() -> new IllegalArgumentException("Trilha não encontrada com o ID: " + trilhaId));

        // Verificar se usuário concluiu todos os módulos da trilha
        List<ProgressoModulo> progressos = progressoModuloRepository.findByUsuarioId(usuario.getId());
        for (Modulo mod : trilha.getModulos()) {
            boolean modConcluido = false;
            for (ProgressoModulo p : progressos) {
                if (p.getModulo().getId().equals(mod.getId()) && p.getStatus() == StatusProgresso.CONCLUIDO) {
                    modConcluido = true;
                    break;
                }
            }
            if (!modConcluido && usuario.getPapel() != com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario.ADMIN) {
                throw new IllegalStateException("Você ainda não concluiu todos os módulos desta trilha para emitir o certificado.");
            }
        }

        Certificado certificado = certificadoRepository.findByUsuarioIdAndTrilhaId(usuario.getId(), trilhaId)
                .orElseGet(() -> {
                    String codigo = "TECH-JAVA-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase() + "-2026";
                    Certificado nuevo = new Certificado(null, usuario, trilha, codigo, java.time.LocalDateTime.now());
                    return certificadoRepository.save(nuevo);
                });

        return CertificadoDto.builder()
                .usuarioNome(usuario.getNome())
                .usuarioEmail(usuario.getEmail())
                .trilhaTitulo(trilha.getTitulo())
                .codigoValidacao(certificado.getCodigoValidacao())
                .dataEmissao(certificado.getDataEmissao())
                .build();
    }

    @Transactional(readOnly = true)
    public CertificadoDto validarCertificado(String codigoValidacao) {
        Certificado cert = certificadoRepository.findByCodigoValidacao(codigoValidacao)
                .orElseThrow(() -> new IllegalArgumentException("Certificado não encontrado ou inválido com o código: " + codigoValidacao));

        return CertificadoDto.builder()
                .usuarioNome(cert.getUsuario().getNome())
                .usuarioEmail(cert.getUsuario().getEmail())
                .trilhaTitulo(cert.getTrilha().getTitulo())
                .codigoValidacao(cert.getCodigoValidacao())
                .dataEmissao(cert.getDataEmissao())
                .build();
    }
}
