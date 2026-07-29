package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.TrilhaDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.TrilhaService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trilhas")
public class TrilhaController {

    private final TrilhaService trilhaService;

    public TrilhaController(TrilhaService trilhaService) {
        this.trilhaService = trilhaService;
    }

    @GetMapping
    public ResponseEntity<List<TrilhaDto.TrilhaResponseDto>> getTrilhas(@AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(trilhaService.getTrilhasComProgresso(usuario));
    }

    @GetMapping("/modulos/{id}")
    public ResponseEntity<TrilhaDto.ModuloResponseDto> getModuloDetalhado(@PathVariable Long id,
                                                                          @AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(trilhaService.getModuloDetalhado(id, usuario));
    }
}
