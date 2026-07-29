package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.SubmissaoDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.SubmissaoService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/submissoes")
public class SubmissaoController {

    private final SubmissaoService submissaoService;

    public SubmissaoController(SubmissaoService submissaoService) {
        this.submissaoService = submissaoService;
    }

    @PostMapping
    public ResponseEntity<SubmissaoDto.SubmissaoResponse> submeter(@Valid @RequestBody SubmissaoDto.SubmissaoRequest request,
                                                                   @AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(submissaoService.submeterExercicio(request, usuario));
    }

    @GetMapping("/exercicio/{exercicioId}")
    public ResponseEntity<List<SubmissaoDto.SubmissaoResponse>> getHistorico(@PathVariable Long exercicioId,
                                                                             @AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(submissaoService.getHistoricoSubmissoes(exercicioId, usuario));
    }
}
