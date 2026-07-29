package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Quiz;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.QuizOpcao;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.Usuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.QuizDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.QuizRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class QuizService {

    private final QuizRepository quizRepository;

    public QuizService(QuizRepository quizRepository) {
        this.quizRepository = quizRepository;
    }

    @Transactional(readOnly = true)
    public List<QuizDto.QuizResponseDto> getQuizzesPorModulo(Long moduloId, Usuario usuario) {
        List<Quiz> quizzes = quizRepository.findByModuloIdOrderByOrdemAsc(moduloId);

        List<QuizDto.QuizResponseDto> resultado = new ArrayList<>();
        for (Quiz q : quizzes) {
            List<QuizDto.QuizOpcaoDto> opcoesDto = new ArrayList<>();
            for (QuizOpcao o : q.getOpcoes()) {
                opcoesDto.add(new QuizDto.QuizOpcaoDto(o.getId(), o.getTextoOpcao()));
            }

            resultado.add(QuizDto.QuizResponseDto.builder()
                    .id(q.getId())
                    .moduloId(moduloId)
                    .pergunta(q.getPergunta())
                    .ordem(q.getOrdem())
                    .opcoes(opcoesDto)
                    .build());
        }

        return resultado;
    }

    @Transactional(readOnly = true)
    public QuizDto.RespostaQuizResponse responderQuiz(QuizDto.RespostaQuizRequest request, Usuario usuario) {
        Quiz quiz = quizRepository.findById(request.getQuizId())
                .orElseThrow(() -> new IllegalArgumentException("Quiz não encontrado com o ID: " + request.getQuizId()));

        QuizOpcao opcaoSelecionada = null;
        for (QuizOpcao op : quiz.getOpcoes()) {
            if (op.getId().equals(request.getOpcaoId())) {
                opcaoSelecionada = op;
                break;
            }
        }

        if (opcaoSelecionada == null) {
            throw new IllegalArgumentException("Opção de resposta inválida para o quiz especificado.");
        }

        if (opcaoSelecionada.isCorreta()) {
            return new QuizDto.RespostaQuizResponse(true, "🎉 Resposta correta! Parabéns pelo aprendizado.");
        } else {
            return new QuizDto.RespostaQuizResponse(false, "❌ Resposta incorreta. Revise o conteúdo do módulo e tente novamente!");
        }
    }
}
