package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.DashboardDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.AlunoDashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/aluno")
public class AlunoDashboardController {

    private final AlunoDashboardService dashboardService;

    public AlunoDashboardController(AlunoDashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/dashboard")
    public ResponseEntity<DashboardDto.AlunoDashboard> getDashboard(@AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(dashboardService.getDashboard(usuario));
    }
}
