package com.techsoluctionsrn.plataforma_ensino_java.controller;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.QuizDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.QuizService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/quizzes")
public class QuizController {

    private final QuizService quizService;

    public QuizController(QuizService quizService) {
        this.quizService = quizService;
    }

    @GetMapping("/modulo/{moduloId}")
    public ResponseEntity<List<QuizDto.QuizResponseDto>> getQuizzes(@PathVariable Long moduloId,
                                                                   @AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(quizService.getQuizzesPorModulo(moduloId, usuario));
    }

    @PostMapping("/responder")
    public ResponseEntity<QuizDto.RespostaQuizResponse> responder(@RequestBody QuizDto.RespostaQuizRequest request,
                                                                  @AuthenticationPrincipal Usuario usuario) {
        return ResponseEntity.ok(quizService.responderQuiz(request, usuario));
    }
}
