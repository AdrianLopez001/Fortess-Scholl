package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.dto.ExecutionResultDto;

/**
 * Interface para o runner de exercícios.
 * Permite mock nos testes unitários sem necessidade de configurar
 * javax.tools ou Docker no ambiente de teste.
 */
public interface SandboxRunner {
    ExecutionResultDto executeSubmission(String codigoEnviado, String testesJunitCode);
}
