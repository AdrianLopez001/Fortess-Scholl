package com.techsoluctionsrn.plataforma_ensino_java.service;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;
import com.techsoluctionsrn.plataforma_ensino_java.dto.ExecutionResultDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.tools.*;
import java.io.*;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.concurrent.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Sandbox de execução de código Java + JUnit 5.
 *
 * Fluxo:
 *  1. Compila o código do aluno + código de teste com javax.tools
 *  2. Executa os testes em uma thread isolada via ClassLoader dinâmico
 *  3. Parseia a saída para extrair: testes passando/falhando, expected vs actual
 *  4. Retorna feedback estruturado com linhas de erro pedagógico
 */
@Service
public class ExerciseRunnerService implements SandboxRunner {

    private static final Logger log = LoggerFactory.getLogger(ExerciseRunnerService.class);

    @Value("${sandbox.execution.timeout-seconds:10}")
    private int timeoutSeconds;

    // Regex para extrair nome da classe pública
    private static final Pattern PUBLIC_CLASS_PATTERN =
            Pattern.compile("public\\s+(?:final\\s+)?class\\s+([A-Za-z0-9_$]+)");

    // Regex para parsear falhas JUnit: "expected: <X> but was: <Y>"
    private static final Pattern EXPECTED_BUT_WAS =
            Pattern.compile("expected: ?<?([^>\\n]+)>? but was: ?<?([^>\\n]+)>?", Pattern.CASE_INSENSITIVE);

    // Regex para linhas de AssertionError/ComparisonFailure
    private static final Pattern ASSERT_FAIL =
            Pattern.compile("org\\.opentest4j\\.AssertionFailedError: (.+)");

    // Regex para detectar qual método de teste falhou
    private static final Pattern TEST_METHOD =
            Pattern.compile("at (\\S+Test\\.\\w+)\\(");

    @Override
    public ExecutionResultDto executeSubmission(String studentCode, String testCode) {
        Path tempDir = null;
        try {
            tempDir = Files.createTempDirectory("sandbox_");

            // Suporte dual: Python vs Java
            if (isPython(studentCode, testCode)) {
                return runPythonSubmission(tempDir, studentCode, testCode);
            }

            // 1. Extrair nomes de classe Java
            String studentClassName = extractClassName(studentCode);
            if (studentClassName == null) studentClassName = "Solution";

            String testClassName = extractClassName(testCode);
            if (testClassName == null) testClassName = "SolutionTest";

            // 2. Gravar arquivos .java no diretório temporário
            Path studentFile = tempDir.resolve(studentClassName + ".java");
            Path testFile    = tempDir.resolve(testClassName + ".java");
            Files.writeString(studentFile, studentCode);
            Files.writeString(testFile, testCode);

            // 3. Compilar com javac
            CompilationResult compilation = compile(studentFile, testFile, tempDir);
            if (!compilation.success()) {
                return ExecutionResultDto.builder()
                        .status(StatusSubmissao.ERRO_COMPILACAO)
                        .errorMessage(compilation.errors())
                        .build();
            }

            // 4. Executar testes via subprocesso isolado (usando classpath do próprio servidor)
            return runTests(tempDir, testClassName);

        } catch (Exception e) {
            log.error("Erro interno no sandbox de testes", e);
            return ExecutionResultDto.builder()
                    .status(StatusSubmissao.FALHA_TESTE)
                    .errorMessage("Erro interno no servidor de sandbox: " + e.getMessage())
                    .build();
        } finally {
            if (tempDir != null) deleteRecursively(tempDir.toFile());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // COMPILAÇÃO
    // ─────────────────────────────────────────────────────────────────────────

    private CompilationResult compile(Path studentFile, Path testFile, Path outputDir) {
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        if (compiler == null) {
            return new CompilationResult(false,
                    "❌ Compilador Java (JDK) não disponível no servidor.\n" +
                    "   Certifique-se que a aplicação rode com JDK (não JRE).");
        }

        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<>();
        try (StandardJavaFileManager fileManager = compiler.getStandardFileManager(diagnostics, null, null)) {

            Iterable<? extends JavaFileObject> units =
                    fileManager.getJavaFileObjects(studentFile.toFile(), testFile.toFile());

            // Classpath = classpath atual do servidor (inclui JUnit 5)
            String classpath = buildClasspath(outputDir);

            List<String> options = Arrays.asList(
                    "-classpath", classpath,
                    "-d", outputDir.toAbsolutePath().toString(),
                    "-encoding", "UTF-8"
            );

            boolean success = compiler.getTask(null, fileManager, diagnostics, options, null, units).call();

            if (!success) {
                StringBuilder errors = new StringBuilder("🔴 ERRO DE COMPILAÇÃO\n");
                errors.append("─".repeat(50)).append("\n");
                for (Diagnostic<? extends JavaFileObject> d : diagnostics.getDiagnostics()) {
                    if (d.getKind() == Diagnostic.Kind.ERROR) {
                        String fileName = d.getSource() != null
                                ? d.getSource().getName().replaceAll(".*/", "")
                                : "?";
                        errors.append(String.format("  Linha %d [%s]: %s%n",
                                d.getLineNumber(),
                                fileName,
                                d.getMessage(Locale.getDefault())));
                    }
                }
                errors.append("\n💡 Dica: Verifique a sintaxe e os tipos de variáveis.");
                return new CompilationResult(false, errors.toString());
            }

            return new CompilationResult(true, null);
        } catch (IOException e) {
            return new CompilationResult(false, "Erro ao gerenciar arquivos de compilação: " + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EXECUÇÃO DOS TESTES — subprocesso isolado via java -cp
    // ─────────────────────────────────────────────────────────────────────────

    private ExecutionResultDto runTests(Path tempDir, String testClassName) {
        try {
            String classpath = buildClasspath(tempDir);

            // Roda org.junit.platform.console.ConsoleLauncher se disponível,
            // caso contrário usa classe wrapper interna para capturar resultados.
            List<String> command = buildTestCommand(classpath, testClassName);

            ProcessBuilder pb = new ProcessBuilder(command);
            pb.directory(tempDir.toFile());
            pb.redirectErrorStream(true);

            Process process = pb.start();
            boolean finished = process.waitFor(timeoutSeconds, TimeUnit.SECONDS);

            if (!finished) {
                process.destroyForcibly();
                return ExecutionResultDto.builder()
                        .status(StatusSubmissao.TIMEOUT)
                        .errorMessage(
                                "⏱️ TIMEOUT — Tempo limite de " + timeoutSeconds + "s excedido.\n\n" +
                                "Possíveis causas:\n" +
                                "  • Laço infinito (verifique condição de parada)\n" +
                                "  • Recursão sem caso base\n" +
                                "  • Operação bloqueante")
                        .build();
            }

            String rawOutput = new String(process.getInputStream().readAllBytes());
            int exitCode = process.exitValue();

            return parseTestOutput(rawOutput, exitCode);

        } catch (Exception e) {
            log.error("Erro ao executar subprocesso de testes", e);
            return ExecutionResultDto.builder()
                    .status(StatusSubmissao.FALHA_TESTE)
                    .errorMessage("Erro ao iniciar executor de testes: " + e.getMessage())
                    .build();
        }
    }

    /**
     * Monta o comando de execução dos testes.
     * Usa JUnit ConsoleLauncher se disponível no classpath atual,
     * caso contrário usa uma classe runner mínima gerada em tempo de execução.
     */
    private List<String> buildTestCommand(String classpath, String testClassName) {
        List<String> cmd = new ArrayList<>();
        cmd.add("java");
        // Aumenta stack para evitar StackOverflow em soluções recursivas
        cmd.add("-Xss4m");
        // Reduz footprint de memória do processo filho
        cmd.add("-Xmx128m");
        cmd.add("-cp");
        cmd.add(classpath);

        // Verifica se ConsoleLauncher está disponível
        try {
            Class.forName("org.junit.platform.console.ConsoleLauncher");
            cmd.add("org.junit.platform.console.ConsoleLauncher");
            cmd.add("--select-class=" + testClassName);
            cmd.add("--details=verbose");
            cmd.add("--fail-if-no-tests");
        } catch (ClassNotFoundException e) {
            // Fallback: usa JUnit Platform Launcher programaticamente
            cmd.set(cmd.size() - 2, classpath); // Não muda o -cp
            // Executa usando o main do Launcher embutido via reflexão wrapper
            cmd.add("org.junit.platform.console.ConsoleLauncher");
            cmd.add("--select-class=" + testClassName);
        }

        return cmd;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PARSER DE SAÍDA DO JUNIT — feedback pedagógico rico
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Converte a saída bruta do JUnit em feedback estruturado e pedagógico.
     *
     * Formato esperado do JUnit ConsoleLauncher --details=verbose:
     *   [OK ] testNome -- XXX ms
     *   [FAILED] testNome -- XXX ms
     *     AssertionFailedError: expected: <5> but was: <0>
     *       at SolutionTest.testNome(SolutionTest.java:10)
     */
    ExecutionResultDto parseTestOutput(String rawOutput, int exitCode) {
        if (rawOutput == null) rawOutput = "";

        List<String> lines = Arrays.asList(rawOutput.split("\\r?\\n"));

        // Extrair estatísticas: "X tests found", "X passed", "X failed"
        int testsFound = extractInt(rawOutput, "(\\d+) tests? found");
        int testsPassed = extractInt(rawOutput, "(\\d+) tests? (successful|passed)");
        int testsFailed = extractInt(rawOutput, "(\\d+) tests? (failed|aborted)");

        // Se não achou pelo padrão verbose, tenta pelos ícones OK/FAILED
        if (testsFound == 0) {
            long okCount = lines.stream().filter(l -> l.contains("[OK]") || l.contains("✔") || l.contains("passed")).count();
            long failCount = lines.stream().filter(l -> l.contains("[FAILED]") || l.contains("✘") || l.contains("FAILED")).count();
            testsPassed = (int) okCount;
            testsFailed = (int) failCount;
            testsFound = testsPassed + testsFailed;
        }

        // ─── SUCESSO ───
        if (exitCode == 0) {
            StringBuilder sb = new StringBuilder();
            sb.append("✅ TODOS OS TESTES PASSARAM!\n");
            sb.append("─".repeat(50)).append("\n\n");

            if (testsFound > 0) {
                sb.append(String.format("📊 Resultado: %d/%d testes aprovados\n\n", testsPassed, testsFound));
            }

            // Listar testes que passaram
            lines.stream()
                 .filter(l -> l.contains("[OK]") || l.contains("✔") || (l.contains("passed") && !l.contains("tests passed")))
                 .forEach(l -> sb.append("   ✅ ").append(l.trim()).append("\n"));

            sb.append("\n🎉 Excelente! Sua solução está correta.");
            return ExecutionResultDto.builder()
                    .status(StatusSubmissao.SUCESSO)
                    .output(sb.toString())
                    .build();
        }

        // ─── FALHA DE TESTES ───
        StringBuilder sb = new StringBuilder();
        sb.append("❌ TESTES FALHARAM\n");
        sb.append("─".repeat(50)).append("\n\n");

        if (testsFound > 0) {
            sb.append(String.format("📊 Resultado: %d/%d testes aprovados, %d falharam\n\n",
                    testsPassed, testsFound, testsFailed));
        }

        // Extrair blocos de falha detalhados
        List<FailedTest> failedTests = extractFailedTests(lines);

        if (!failedTests.isEmpty()) {
            sb.append("🔍 DETALHES DAS FALHAS:\n");
            sb.append("─".repeat(50)).append("\n");
            for (int i = 0; i < failedTests.size(); i++) {
                FailedTest ft = failedTests.get(i);
                sb.append(String.format("\n%d. ❌ %s\n", i + 1, ft.methodName()));
                if (ft.expected() != null && ft.actual() != null) {
                    sb.append(String.format("   Esperado : %s\n", ft.expected()));
                    sb.append(String.format("   Recebido : %s\n", ft.actual()));
                } else if (ft.message() != null) {
                    sb.append("   Erro     : ").append(ft.message()).append("\n");
                }
                if (ft.location() != null) {
                    sb.append("   Local    : ").append(ft.location()).append("\n");
                }
            }
        } else {
            // Fallback: mostrar output bruto mas limpo
            sb.append("📋 Saída dos Testes:\n");
            lines.stream()
                 .filter(l -> !l.isBlank() && !l.startsWith("Thanks for using") && !l.contains("JUnit"))
                 .limit(30)
                 .forEach(l -> sb.append("   ").append(l).append("\n"));
        }

        // Sugestão de revisão
        sb.append("\n💡 Revise sua lógica e tente novamente. Se continuar tendo dificuldades, uma dica será exibida.\n");

        return ExecutionResultDto.builder()
                .status(StatusSubmissao.FALHA_TESTE)
                .output(sb.toString())
                .errorMessage(sb.toString())
                .build();
    }

    /**
     * Extrai blocos de testes falhados da saída do JUnit (verbose).
     */
    private List<FailedTest> extractFailedTests(List<String> lines) {
        List<FailedTest> result = new ArrayList<>();
        String currentMethod = null;
        String expected = null;
        String actual = null;
        String message = null;
        String location = null;

        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i).trim();

            // Detectar início de falha: "[FAILED] methodName"
            if (line.contains("[FAILED]") || line.contains("FAILED")) {
                // Salvar teste anterior se existir
                if (currentMethod != null) {
                    result.add(new FailedTest(currentMethod, expected, actual, message, location));
                }
                currentMethod = extractTestName(line);
                expected = null; actual = null; message = null; location = null;
                continue;
            }

            // Extrair expected/actual
            Matcher expMatcher = EXPECTED_BUT_WAS.matcher(line);
            if (expMatcher.find()) {
                expected = expMatcher.group(1).trim();
                actual   = expMatcher.group(2).trim();
                continue;
            }

            // Extrair AssertionError message
            Matcher assertMatcher = ASSERT_FAIL.matcher(line);
            if (assertMatcher.find() && message == null) {
                message = assertMatcher.group(1).trim();
                continue;
            }

            // Extrair localização (linha do código do aluno)
            if (line.startsWith("at Solution") || (line.startsWith("at ") && !line.contains("junit") && !line.contains("java."))) {
                if (location == null) {
                    // Extrai só "Solution.metodo(Solution.java:10)"
                    location = line.replace("at ", "").trim();
                }
            }
        }

        // Adicionar último teste
        if (currentMethod != null) {
            result.add(new FailedTest(currentMethod, expected, actual, message, location));
        }

        return result;
    }

    private String extractTestName(String line) {
        // "[FAILED] testSoma(SolutionTest) -- 5 ms"
        Pattern p = Pattern.compile("\\[FAILED\\]\\s+(\\w+)");
        Matcher m = p.matcher(line);
        if (m.find()) return m.group(1);

        // "SolutionTest > testSoma() FAILED"
        Pattern p2 = Pattern.compile("(\\w+)\\(\\) ?(?:FAILED|--)?");
        Matcher m2 = p2.matcher(line);
        if (m2.find()) return m2.group(1) + "()";

        return line.replaceAll(".*\\[FAILED\\]\\s*", "").replaceAll("\\s*--.*", "").trim();
    }

    private int extractInt(String text, String regex) {
        Pattern p = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(text);
        if (m.find()) {
            try { return Integer.parseInt(m.group(1)); } catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // UTILITÁRIOS
    // ─────────────────────────────────────────────────────────────────────────

    private String buildClasspath(Path outputDir) {
        String serverClasspath = System.getProperty("java.class.path", "");
        return outputDir.toAbsolutePath() + File.pathSeparator + serverClasspath;
    }

    private String extractClassName(String code) {
        Matcher m = PUBLIC_CLASS_PATTERN.matcher(code);
        return m.find() ? m.group(1) : null;
    }

    private boolean isPython(String studentCode, String testCode) {
        if (studentCode == null) return false;
        String combined = (studentCode + "\n" + (testCode != null ? testCode : "")).toLowerCase();
        return combined.contains("def ") || combined.contains("import unittest") || combined.contains("import socket")
                || combined.contains("import paramiko") || combined.contains("import requests")
                || combined.contains("#!/usr/bin/env python") || (!combined.contains("public class") && combined.contains("import "));
    }

    private ExecutionResultDto runPythonSubmission(Path tempDir, String studentCode, String testCode) {
        try {
            Path studentFile = tempDir.resolve("solution.py");
            Path testFile    = tempDir.resolve("test_solution.py");

            Files.writeString(studentFile, studentCode);
            Files.writeString(testFile, testCode != null ? testCode : "");

            List<String> command = List.of("python3", "-m", "unittest", "test_solution.py");
            ProcessBuilder pb = new ProcessBuilder(command);
            pb.directory(tempDir.toFile());
            pb.redirectErrorStream(true);

            Process process = pb.start();
            boolean finished = process.waitFor(timeoutSeconds, TimeUnit.SECONDS);

            if (!finished) {
                process.destroyForcibly();
                return ExecutionResultDto.builder()
                        .status(StatusSubmissao.TIMEOUT)
                        .errorMessage("⏱️ TIMEOUT — Tempo limite de " + timeoutSeconds + "s excedido no script Python.")
                        .build();
            }

            String output = new String(process.getInputStream().readAllBytes());
            int exitCode = process.exitValue();

            if (exitCode == 0) {
                return ExecutionResultDto.builder()
                        .status(StatusSubmissao.SUCESSO)
                        .output("✅ TODOS OS TESTES EM PYTHON PASSARAM!\n\n" + output)
                        .build();
            } else {
                return ExecutionResultDto.builder()
                        .status(StatusSubmissao.FALHA_TESTE)
                        .errorMessage(output)
                        .output(output)
                        .build();
            }
        } catch (Exception e) {
            return ExecutionResultDto.builder()
                    .status(StatusSubmissao.FALHA_TESTE)
                    .errorMessage("Erro ao executar subprocesso Python: " + e.getMessage())
                    .build();
        }
    }

    private void deleteRecursively(File file) {
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            if (files != null) Arrays.stream(files).forEach(this::deleteRecursively);
        }
        file.delete();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // TIPOS INTERNOS
    // ─────────────────────────────────────────────────────────────────────────

    private record CompilationResult(boolean success, String errors) {}

    private record FailedTest(String methodName, String expected, String actual,
                              String message, String location) {}
}
