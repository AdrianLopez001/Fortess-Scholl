package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.*;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import com.techsoluctionsrn.plataforma_ensino_java.dto.ExecutionResultDto;
import com.techsoluctionsrn.plataforma_ensino_java.dto.SubmissaoDto;
import com.techsoluctionsrn.plataforma_ensino_java.service.SandboxRunner;
import com.techsoluctionsrn.plataforma_ensino_java.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("SubmissaoService — Sistema Profissional de Avaliação")
class SubmissaoServiceTest {

    @Mock ExercicioRepository exercicioRepository;
    @Mock SubmissaoRepository submissaoRepository;
    @Mock ProgressoModuloRepository progressoModuloRepository;
    @Mock SandboxRunner exerciseRunnerService;
    @Mock UsuarioRepository usuarioRepository;
    @Mock AtividadeDiariaRepository atividadeDiariaRepository;

    @InjectMocks SubmissaoService submissaoService;

    private Usuario usuario;
    private Modulo modulo;
    private Exercicio exercicio;

    @BeforeEach
    void setUp() {
        Trilha trilha = new Trilha();
        trilha.setId(1L);

        modulo = new Modulo();
        modulo.setId(10L);
        modulo.setTrilha(trilha);
        modulo.setOrdem(1);

        exercicio = new Exercicio();
        exercicio.setId(100L);
        exercicio.setModulo(modulo);
        exercicio.setPontosBase(100);
        exercicio.setDicaHint("Use o método stream().filter()");
        exercicio.setNivelDificuldade("MEDIUM");
        exercicio.setTestesJunitCode("// test code");

        usuario = new Usuario();
        usuario.setId(1L);
        usuario.setNome("Julio Cesar");
        usuario.setEmail("julio@techsoluctionsrn.com");
        usuario.setPapel(PapelUsuario.ALUNO);
        usuario.setXpTotal(500);
    }

    @Nested
    @DisplayName("Cálculo de XP e Sistema de Pontuação")
    class XPCalculation {

        @Test
        @DisplayName("Deve conceder 100% dos pontos na primeira tentativa")
        void deveConcederPontosIntegralNaPrimeiraTentativa() {
            // Arrange
            when(exercicioRepository.findById(100L)).thenReturn(Optional.of(exercicio));
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(new ArrayList<>()); // Nenhuma tentativa anterior

            ExecutionResultDto resultado = new ExecutionResultDto();
            resultado.setStatus(StatusSubmissao.SUCESSO);
            resultado.setOutput("Tests passed: 3/3");
            when(exerciseRunnerService.executeSubmission(anyString(), anyString())).thenReturn(resultado);

            when(exercicioRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(exercicio));
            when(progressoModuloRepository.findByUsuarioIdAndModuloId(1L, 10L)).thenReturn(Optional.empty());
            when(atividadeDiariaRepository.findByUsuarioIdAndData(1L, LocalDate.now())).thenReturn(Optional.empty());
            when(submissaoRepository.findAll()).thenReturn(new ArrayList<>());

            SubmissaoDto.SubmissaoRequest request = new SubmissaoDto.SubmissaoRequest(100L, "public class Solucao {}");

            // Act
            SubmissaoDto.SubmissaoResponse response = submissaoService.submeterExercicio(request, usuario);

            // Assert
            assertEquals(100, response.getPontosGanhos(), "Primeira tentativa deve conceder 100 pontos");
            assertEquals(StatusSubmissao.SUCESSO, response.getStatus());
            verify(usuarioRepository).save(usuario);
        }

        @Test
        @DisplayName("Deve conceder 70% dos pontos na segunda tentativa")
        void deveConceder70PorcentoNaSegundaTentativa() {
            // Arrange
            Submissao tentativaAnterior = new Submissao();
            tentativaAnterior.setStatus(StatusSubmissao.FALHA_TESTE);

            when(exercicioRepository.findById(100L)).thenReturn(Optional.of(exercicio));
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(List.of(tentativaAnterior)); // 1 tentativa anterior (falha)

            ExecutionResultDto resultado = new ExecutionResultDto();
            resultado.setStatus(StatusSubmissao.SUCESSO);
            resultado.setOutput("Tests passed: 3/3");
            when(exerciseRunnerService.executeSubmission(anyString(), anyString())).thenReturn(resultado);

            when(exercicioRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(exercicio));
            when(progressoModuloRepository.findByUsuarioIdAndModuloId(1L, 10L)).thenReturn(Optional.empty());
            when(atividadeDiariaRepository.findByUsuarioIdAndData(1L, LocalDate.now())).thenReturn(Optional.empty());
            when(submissaoRepository.findAll()).thenReturn(new ArrayList<>());

            SubmissaoDto.SubmissaoRequest request = new SubmissaoDto.SubmissaoRequest(100L, "public class Solucao {}");

            // Act
            SubmissaoDto.SubmissaoResponse response = submissaoService.submeterExercicio(request, usuario);

            // Assert
            assertEquals(70, response.getPontosGanhos(), "Segunda tentativa deve conceder 70 pontos");
        }

        @Test
        @DisplayName("Não deve adicionar XP em resposta errada")
        void naoDeveAdicionarXPEmRespostaErrada() {
            // Arrange
            when(exercicioRepository.findById(100L)).thenReturn(Optional.of(exercicio));
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(new ArrayList<>());

            ExecutionResultDto resultado = new ExecutionResultDto();
            resultado.setStatus(StatusSubmissao.FALHA_TESTE);
            resultado.setErrorMessage("Test 1 FAILED: expected 20.0 but was 0.0");
            when(exerciseRunnerService.executeSubmission(anyString(), anyString())).thenReturn(resultado);

            when(exercicioRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(exercicio));
            when(progressoModuloRepository.findByUsuarioIdAndModuloId(1L, 10L)).thenReturn(Optional.empty());

            SubmissaoDto.SubmissaoRequest request = new SubmissaoDto.SubmissaoRequest(100L, "public class Solucao {}");

            // Act
            SubmissaoDto.SubmissaoResponse response = submissaoService.submeterExercicio(request, usuario);

            // Assert
            assertEquals(0, response.getPontosGanhos(), "Erro não deve gerar XP");
            verify(usuarioRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("Dicas Pedagógicas")
    class DicasPedagogicas {

        @Test
        @DisplayName("Deve retornar dica após 2 tentativas falhas")
        void deveRetornarDicaApos2TentativasFalhas() {
            // Arrange
            Submissao falha1 = new Submissao(); falha1.setStatus(StatusSubmissao.FALHA_TESTE);
            Submissao falha2 = new Submissao(); falha2.setStatus(StatusSubmissao.FALHA_TESTE);

            when(exercicioRepository.findById(100L)).thenReturn(Optional.of(exercicio));
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(List.of(falha1, falha2)); // 2 tentativas anteriores

            ExecutionResultDto resultado = new ExecutionResultDto();
            resultado.setStatus(StatusSubmissao.FALHA_TESTE);
            resultado.setErrorMessage("Test FAILED");
            when(exerciseRunnerService.executeSubmission(anyString(), anyString())).thenReturn(resultado);

            when(exercicioRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(exercicio));
            when(progressoModuloRepository.findByUsuarioIdAndModuloId(1L, 10L)).thenReturn(Optional.empty());

            SubmissaoDto.SubmissaoRequest request = new SubmissaoDto.SubmissaoRequest(100L, "// código incorreto");

            // Act
            SubmissaoDto.SubmissaoResponse response = submissaoService.submeterExercicio(request, usuario);

            // Assert
            assertNotNull(response.getDica(), "Dica deve ser retornada após 2+ tentativas falhas");
            assertEquals("Use o método stream().filter()", response.getDica());
        }

        @Test
        @DisplayName("Não deve retornar dica na primeira tentativa falha")
        void naoDeveRetornarDicaNaPrimeiraTentativa() {
            // Arrange
            when(exercicioRepository.findById(100L)).thenReturn(Optional.of(exercicio));
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(new ArrayList<>()); // Nenhuma tentativa anterior

            ExecutionResultDto resultado = new ExecutionResultDto();
            resultado.setStatus(StatusSubmissao.FALHA_TESTE);
            resultado.setErrorMessage("Test FAILED");
            when(exerciseRunnerService.executeSubmission(anyString(), anyString())).thenReturn(resultado);

            when(exercicioRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(exercicio));
            when(progressoModuloRepository.findByUsuarioIdAndModuloId(1L, 10L)).thenReturn(Optional.empty());

            SubmissaoDto.SubmissaoRequest request = new SubmissaoDto.SubmissaoRequest(100L, "// código incorreto");

            // Act
            SubmissaoDto.SubmissaoResponse response = submissaoService.submeterExercicio(request, usuario);

            // Assert
            assertNull(response.getDica(), "Dica NÃO deve ser retornada na primeira tentativa");
        }
    }

    @Nested
    @DisplayName("Regra de Nota Mínima 70%")
    class NotaMinima {

        @Test
        @DisplayName("Módulo deve ser concluído ao atingir 70% dos exercícios")
        void moduloDeveSerConcluidoCom70PorCento() {
            // Arrange: 2 exercícios, 1 concluído = 50% → NÃO conclui
            Exercicio ex2 = new Exercicio();
            ex2.setId(101L);
            ex2.setModulo(modulo);
            ex2.setPontosBase(100);
            modulo.setExercicios(List.of(exercicio, ex2));

            when(exercicioRepository.findById(100L)).thenReturn(Optional.of(exercicio));
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(new ArrayList<>());

            ExecutionResultDto resultado = new ExecutionResultDto();
            resultado.setStatus(StatusSubmissao.SUCESSO);
            resultado.setOutput("Tests passed: 1/1");
            when(exerciseRunnerService.executeSubmission(anyString(), anyString())).thenReturn(resultado);

            when(exercicioRepository.findByModuloIdOrderByOrdemAsc(10L)).thenReturn(List.of(exercicio, ex2));

            // Exercício 1 (100): SUCESSO, Exercício 2 (101): ainda não resolvido
            Submissao submissaoSucesso = new Submissao();
            submissaoSucesso.setStatus(StatusSubmissao.SUCESSO);
            submissaoSucesso.setExercicio(exercicio);
            submissaoSucesso.setUsuario(usuario);

            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 100L))
                    .thenReturn(new ArrayList<>()) // antes da submissão
                    .thenReturn(List.of(submissaoSucesso)); // depois da submissão (para cálculo de percentual)
            when(submissaoRepository.findByUsuarioIdAndExercicioIdOrderByDataSubmissaoDesc(1L, 101L))
                    .thenReturn(new ArrayList<>()); // Ex 2 não feito

            when(progressoModuloRepository.findByUsuarioIdAndModuloId(1L, 10L)).thenReturn(Optional.empty());
            when(atividadeDiariaRepository.findByUsuarioIdAndData(1L, LocalDate.now())).thenReturn(Optional.empty());
            when(submissaoRepository.findAll()).thenReturn(new ArrayList<>());

            // Act
            SubmissaoDto.SubmissaoResponse response = submissaoService.submeterExercicio(
                    new SubmissaoDto.SubmissaoRequest(100L, "// solucao"), usuario);

            // Assert
            assertFalse(response.isModuloConcluido(), "Com apenas 50% (1/2 exercícios), módulo NÃO deve ser concluído");
        }
    }
}
