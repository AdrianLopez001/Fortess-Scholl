package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.*;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.dto.QuizDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.QuizRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("QuizService — Quizzes Teóricos")
class QuizServiceTest {

    @Mock QuizRepository quizRepository;
    @InjectMocks QuizService quizService;

    private Usuario usuario;
    private Quiz quiz;
    private QuizOpcao opcaoCorreta;
    private QuizOpcao opcaoErrada;

    @BeforeEach
    void setUp() {
        usuario = new Usuario();
        usuario.setId(1L);
        usuario.setPapel(PapelUsuario.ALUNO);

        opcaoCorreta = new QuizOpcao();
        opcaoCorreta.setId(1L);
        opcaoCorreta.setTextoOpcao("32 bits");
        opcaoCorreta.setCorreta(true);

        opcaoErrada = new QuizOpcao();
        opcaoErrada.setId(2L);
        opcaoErrada.setTextoOpcao("64 bits");
        opcaoErrada.setCorreta(false);

        quiz = new Quiz();
        quiz.setId(1L);
        quiz.setPergunta("Qual o tamanho do int em Java?");
        quiz.setOrdem(1);
        quiz.setOpcoes(List.of(opcaoCorreta, opcaoErrada));
    }

    @Test
    @DisplayName("Deve retornar lista de quizzes do módulo")
    void deveRetornarQuizzesDoModulo() {
        when(quizRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(quiz));

        List<QuizDto.QuizResponseDto> resultado = quizService.getQuizzesPorModulo(10L, usuario);

        assertEquals(1, resultado.size());
        assertEquals("Qual o tamanho do int em Java?", resultado.get(0).getPergunta());
        assertEquals(2, resultado.get(0).getOpcoes().size());
        // Não expõe qual opção é a correta!
    }

    @Test
    @DisplayName("Deve validar resposta correta e retornar feedback positivo")
    void deveValidarRespostaCorreta() {
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));

        QuizDto.RespostaQuizRequest request = new QuizDto.RespostaQuizRequest(1L, 1L); // opcao 1 = correta
        QuizDto.RespostaQuizResponse resposta = quizService.responderQuiz(request, usuario);

        assertTrue(resposta.isCorreto());
        assertNotNull(resposta.getMensagem());
        assertTrue(resposta.getMensagem().contains("correta"));
    }

    @Test
    @DisplayName("Deve validar resposta incorreta e retornar feedback construtivo")
    void deveValidarRespostaErrada() {
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));

        QuizDto.RespostaQuizRequest request = new QuizDto.RespostaQuizRequest(1L, 2L); // opcao 2 = errada
        QuizDto.RespostaQuizResponse resposta = quizService.responderQuiz(request, usuario);

        assertFalse(resposta.isCorreto());
        assertNotNull(resposta.getMensagem());
    }

    @Test
    @DisplayName("Deve lançar exceção para quiz inexistente")
    void deveLancarExcecaoParaQuizInexistente() {
        when(quizRepository.findById(999L)).thenReturn(Optional.empty());

        QuizDto.RespostaQuizRequest request = new QuizDto.RespostaQuizRequest(999L, 1L);

        assertThrows(IllegalArgumentException.class, () -> quizService.responderQuiz(request, usuario));
    }

    @Test
    @DisplayName("Deve lançar exceção para opção inválida")
    void deveLancarExcecaoParaOpcaoInvalida() {
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));

        QuizDto.RespostaQuizRequest request = new QuizDto.RespostaQuizRequest(1L, 999L); // opção não existe
        
        assertThrows(IllegalArgumentException.class, () -> quizService.responderQuiz(request, usuario));
    }
}
