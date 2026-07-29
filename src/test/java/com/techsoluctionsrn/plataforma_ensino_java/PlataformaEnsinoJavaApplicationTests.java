package com.techsoluctionsrn.plataforma_ensino_java;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

// Este teste sobe o contexto Spring completo com banco H2 em memória.
// Para rodar, certifique-se de que application-test.properties está configurado.
@SpringBootTest
@ActiveProfiles("test")
class PlataformaEnsinoJavaApplicationTests {

    @Test
    void contextLoads() {
        // Verifica se o contexto Spring inicializa sem erros
    }

}
