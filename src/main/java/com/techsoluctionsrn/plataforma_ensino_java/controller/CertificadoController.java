package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.CertificadoDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.CertificadoService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/certificados")
public class CertificadoController {

    private final CertificadoService certificadoService;

    public CertificadoController(CertificadoService certificadoService) {
        this.certificadoService = certificadoService;
    }

    @GetMapping("/trilha/{trilhaId}")
    public ResponseEntity<CertificadoDto> emitirCertificado(@PathVariable Long trilhaId,
                                                            @AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(certificadoService.obterOuEmitirCertificado(trilhaId, usuario));
    }

    @GetMapping("/validar/{codigo}")
    public ResponseEntity<CertificadoDto> validarCertificado(@PathVariable String codigo) {
        return ResponseEntity.ok(certificadoService.validarCertificado(codigo));
    }
}
