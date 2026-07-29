package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.AuthDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.UsuarioRepository;
import com.techsoluctionsrn.plataforma_ensino_java.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/usuarios")
public class AdminUserController {

    private final UsuarioRepository usuarioRepository;
    private final AuthService authService;

    public AdminUserController(UsuarioRepository usuarioRepository, AuthService authService) {
        this.usuarioRepository = usuarioRepository;
        this.authService = authService;
    }

    @GetMapping
    public ResponseEntity<List<AuthDto.UserDto>> listarUsuarios() {
        List<Usuario> usuarios = usuarioRepository.findAll();
        List<AuthDto.UserDto> dtos = usuarios.stream().map(u -> AuthDto.UserDto.builder()
                .id(u.getId())
                .nome(u.getNome())
                .email(u.getEmail())
                .papel(u.getPapel())
                .build()).toList();
        return ResponseEntity.ok(dtos);
    }

    @PostMapping
    public ResponseEntity<AuthDto.AuthResponse> cadastrarUsuario(@Valid @RequestBody AuthDto.RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> removerUsuario(@PathVariable Long id) {
        usuarioRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
