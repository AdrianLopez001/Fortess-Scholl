package com.techsoluctionsrn.plataforma_ensino_java;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.*;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;
import com.techsoluctionsrn.plataforma_ensino_java.dto.TrilhaDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.*;
import com.techsoluctionsrn.plataforma_ensino_java.service.TrilhaService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import org.springframework.transaction.annotation.Transactional;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@SpringBootTest
public class ExportDataTest {

    @Autowired
    private ModuloRepository moduloRepository;

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private TrilhaService trilhaService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @Transactional
    public void exportStaticData() throws Exception {
        Usuario adminUser = Usuario.builder()
                .id(1L)
                .nome("Adrian")
                .email("adrian@techsoluctionsrn.com")
                .papel(PapelUsuario.ADMIN)
                .build();

        List<TrilhaDto.TrilhaResponseDto> trilhas = trilhaService.getTrilhasComProgresso(adminUser);

        Map<Long, Map<String, Object>> modulosMap = new LinkedHashMap<>();
        Map<Long, List<Map<String, Object>>> quizzesMap = new LinkedHashMap<>();

        List<Modulo> todosModulos = moduloRepository.findAll();
        for (Modulo m : todosModulos) {
            Map<String, Object> mData = new LinkedHashMap<>();
            mData.put("id", m.getId());
            mData.put("trilhaId", m.getTrilha().getId());
            mData.put("ordem", m.getOrdem());
            mData.put("titulo", m.getTitulo());
            mData.put("descricao", m.getDescricao());
            mData.put("conteudoMarkdown", m.getConteudoMarkdown());

            List<Map<String, Object>> exList = new ArrayList<>();
            if (m.getExercicios() != null) {
                for (Exercicio ex : m.getExercicios()) {
                    Map<String, Object> exMap = new LinkedHashMap<>();
                    exMap.put("id", ex.getId());
                    exMap.put("ordem", ex.getOrdem());
                    exMap.put("titulo", ex.getTitulo());
                    exMap.put("enunciado", ex.getEnunciado());
                    exMap.put("codigoTemplate", ex.getCodigoTemplate());
                    exMap.put("nivelDificuldade", ex.getNivelDificuldade() != null ? String.valueOf(ex.getNivelDificuldade()) : "EASY");
                    exMap.put("pontosBase", ex.getPontosBase());
                    exList.add(exMap);
                }
            }
            mData.put("exercicios", exList);
            modulosMap.put(m.getId(), mData);

            List<Quiz> quizzes = quizRepository.findByModuloIdOrderByOrdemAsc(m.getId());
            List<Map<String, Object>> qList = new ArrayList<>();
            for (Quiz q : quizzes) {
                Map<String, Object> qMap = new LinkedHashMap<>();
                qMap.put("id", q.getId());
                qMap.put("pergunta", q.getPergunta());
                qMap.put("ordem", q.getOrdem());
                
                List<Map<String, Object>> opList = new ArrayList<>();
                if (q.getOpcoes() != null) {
                    for (QuizOpcao op : q.getOpcoes()) {
                        Map<String, Object> opMap = new LinkedHashMap<>();
                        opMap.put("id", op.getId());
                        opMap.put("texto", op.getTextoOpcao());
                        opMap.put("correta", op.isCorreta());
                        opList.add(opMap);
                    }
                }
                qMap.put("opcoes", opList);
                qList.add(qMap);
            }
            quizzesMap.put(m.getId(), qList);
        }

        String trilhasJson = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(trilhas);
        String modulosJson = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(modulosMap);
        String quizzesJson = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(quizzesMap);

        StringBuilder jsBuilder = new StringBuilder();
        jsBuilder.append("// ══════════════════════════════════════════════════════════════\n");
        jsBuilder.append("// TechSoluctionsRN — Java Academy — static-data.js\n");
        jsBuilder.append("// Dados Completos Estáticos (Trilhas, Módulos, Exercícios e Quizzes)\n");
        jsBuilder.append("// ══════════════════════════════════════════════════════════════\n\n");
        jsBuilder.append("window.STATIC_TRILHAS = ").append(trilhasJson).append(";\n\n");
        jsBuilder.append("window.STATIC_MODULOS = ").append(modulosJson).append(";\n\n");
        jsBuilder.append("window.STATIC_QUIZZES = ").append(quizzesJson).append(";\n");

        String content = jsBuilder.toString();
        Files.writeString(Paths.get("src/main/resources/static/js/static-data.js"), content);
        Files.writeString(Paths.get("js/static-data.js"), content);
        System.out.println("✅ static-data.js exportado com sucesso! Tamanho: " + content.length() + " bytes");
    }
}
