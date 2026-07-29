package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.entity.*;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;
import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusProgresso;
import com.techsoluctionsrn.plataforma_ensino_java.dto.CertificadoDto;
import com.techsoluctionsrn.plataforma_ensino_java.repository.*;
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
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CertificadoService — Emissão e Validação de Certificados")
class CertificadoServiceTest {

    @Mock CertificadoRepository certificadoRepository;
    @Mock TrilhaRepository trilhaRepository;
    @Mock ProgressoModuloRepository progressoModuloRepository;

    @InjectMocks CertificadoService certificadoService;

    private Usuario usuarioAdmin;
    private Trilha trilha;
    private Modulo modulo;

    @BeforeEach
    void setUp() {
        usuarioAdmin = new Usuario();
        usuarioAdmin.setId(1L);
        usuarioAdmin.setNome("Adrian Lopes");
        usuarioAdmin.setEmail("adrian@techsoluctionsrn.com");
        usuarioAdmin.setPapel(PapelUsuario.ADMIN);

        modulo = new Modulo();
        modulo.setId(1L);
        modulo.setOrdem(1);

        trilha = new Trilha();
        trilha.setId(1L);
        trilha.setTitulo("Java Júnior (Fundamentos)");
        trilha.setModulos(List.of(modulo));
    }

    @Test
    @DisplayName("Admin deve poder emitir certificado sem restrição de conclusão")
    void adminDeveEmitirCertificadoSemRestricao() {
        when(trilhaRepository.findById(1L)).thenReturn(Optional.of(trilha));
        when(progressoModuloRepository.findByUsuarioId(1L)).thenReturn(List.of()); // Sem progresso
        when(certificadoRepository.findByUsuarioIdAndTrilhaId(1L, 1L)).thenReturn(Optional.empty());

        Certificado cert = new Certificado();
        cert.setCodigoValidacao("TECH-JAVA-TEST-2026");
        cert.setUsuario(usuarioAdmin);
        cert.setTrilha(trilha);
        when(certificadoRepository.save(any())).thenReturn(cert);

        CertificadoDto dto = certificadoService.obterOuEmitirCertificado(1L, usuarioAdmin);

        assertNotNull(dto);
        verify(certificadoRepository).save(any(Certificado.class));
    }

    @Test
    @DisplayName("Deve retornar certificado existente sem criar novo")
    void deveRetornarCertificadoExistente() {
        Certificado certExistente = new Certificado();
        certExistente.setCodigoValidacao("TECH-JAVA-EXISTING-2026");
        certExistente.setUsuario(usuarioAdmin);
        certExistente.setTrilha(trilha);

        when(trilhaRepository.findById(1L)).thenReturn(Optional.of(trilha));
        when(progressoModuloRepository.findByUsuarioId(1L)).thenReturn(List.of());
        when(certificadoRepository.findByUsuarioIdAndTrilhaId(1L, 1L)).thenReturn(Optional.of(certExistente));

        CertificadoDto dto = certificadoService.obterOuEmitirCertificado(1L, usuarioAdmin);

        assertEquals("TECH-JAVA-EXISTING-2026", dto.getCodigoValidacao());
        verify(certificadoRepository, never()).save(any()); // Não deve salvar de novo
    }

    @Test
    @DisplayName("Deve validar certificado por código")
    void deveValidarCertificadoPorCodigo() {
        Certificado cert = new Certificado();
        cert.setCodigoValidacao("TECH-JAVA-ABC123-2026");
        cert.setUsuario(usuarioAdmin);
        cert.setTrilha(trilha);

        when(certificadoRepository.findByCodigoValidacao("TECH-JAVA-ABC123-2026")).thenReturn(Optional.of(cert));

        CertificadoDto dto = certificadoService.validarCertificado("TECH-JAVA-ABC123-2026");

        assertNotNull(dto);
        assertEquals("Adrian Lopes", dto.getUsuarioNome());
        assertEquals("Java Júnior (Fundamentos)", dto.getTrilhaTitulo());
    }

    @Test
    @DisplayName("Deve lançar exceção para código de certificado inválido")
    void deveLancarExcecaoParaCodigoInvalido() {
        when(certificadoRepository.findByCodigoValidacao("CODIGO-INVALIDO")).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, 
            () -> certificadoService.validarCertificado("CODIGO-INVALIDO"));
    }

    @Test
    @DisplayName("Aluno sem conclusão não deve receber certificado")
    void alunoSemConclusaoNaoDeveReceberCertificado() {
        Usuario aluno = new Usuario();
        aluno.setId(2L);
        aluno.setNome("Julio Cesar");
        aluno.setPapel(PapelUsuario.ALUNO);

        // Módulo existente mas aluno não concluiu
        when(trilhaRepository.findById(1L)).thenReturn(Optional.of(trilha));
        when(progressoModuloRepository.findByUsuarioId(2L)).thenReturn(List.of()); // Sem progresso

        assertThrows(IllegalStateException.class,
            () -> certificadoService.obterOuEmitirCertificado(1L, aluno));
    }
}
