package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.dto.AdminProgressDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.AdminService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @GetMapping("/progresso")
    public ResponseEntity<List<AdminProgressDto>> getProgressoGeralEquipe() {
        return ResponseEntity.ok(adminService.getProgressoGeralEquipe());
    }
}
