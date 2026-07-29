-- Modulos Adicionais para Trilha 1 (Java Júnior)
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(5, 1, 'Herança, Interfaces e Polimorfismo', 
'Aprenda a reutilizar código e criar abstrações flexíveis utilizando herança (`extends`), interfaces (`implements`) e polimorfismo em Java.', 
'# Módulo 5: Herança, Interfaces e Polimorfismo

## 1. Herança em Java
Permite que uma subclasse herde atributos e métodos de uma superclasse usando a palavra-chave `extends`.

```java
public class Funcionario {
    protected String nome;
    protected double salario;

    public double getBonificacao() {
        return this.salario * 0.1;
    }
}

public class Gerente extends Funcionario {
    @Override
    public double getBonificacao() {
        return this.salario * 0.2;
    }
}
```

## 2. Interfaces
Contratos puramente abstratos que definem comportamentos obrigatórios para as classes implementadoras.

```java
public interface Autenticavel {
    boolean autenticar(String senha);
}
```', 5),

(6, 1, 'Coleções no Java (List, Set, Map)', 
'Dominando o Collections Framework do Java: `ArrayList`, `HashSet`, `HashMap` e iteração eficiente.', 
'# Módulo 6: Coleções (List, Set, Map)

## 1. List (Coleções Ordenadas que Aceitam Duplicatas)
```java
List<String> nomes = new ArrayList<>();
nomes.add("Julio");
nomes.add("Claudia");
```

## 2. Set (Coleções de Elementos Únicos)
```java
Set<Integer> idsUnicos = new HashSet<>();
idsUnicos.add(101);
```

## 3. Map (Chave -> Valor)
```java
Map<String, String> configuracoes = new HashMap<>();
configuracoes.put("db.host", "localhost");
```', 6),

(7, 1, 'Tratamento de Exceções', 
'Como lidar com erros em tempo de execução usando `try-catch-finally`, exceções checadas (Checked) e não checadas (Unchecked).', 
'# Módulo 7: Tratamento de Exceções

## 1. Estrutura `try-catch`
```java
try {
    int resultado = 10 / 0;
} catch (ArithmeticException e) {
    System.err.println("Erro: Divisão por zero não permitida!");
} finally {
    System.out.println("Sempre executado");
}
```', 7),

(8, 1, 'Introdução a Streams e Lambdas', 
'Processamento funcional de coleções com a Stream API do Java 8+.', 
'# Módulo 8: Streams e Expressões Lambda

## 1. Filtrando e Mapeando Coleções
```java
List<String> aprovados = alunos.stream()
    .filter(a -> a.getNota() >= 7.0)
    .map(Aluno::getNome)
    .collect(Collectors.toList());
```', 8),

(9, 1, 'Git Básico & Fluxo da Equipe', 
'Padrão de Git usado na TechSoluctionsRN (branches `main`, `develop`, `feature/*`, Pull Requests).', 
'# Módulo 9: Git & Workflow do Time

1. `git checkout -b feature/novo-modulo`
2. Commit limpo e descritivo
3. Pull Request com revisão do Adrian.', 9),

(10, 1, 'Introdução ao Spring Boot', 
'Estrutura de uma API REST no Spring Boot: Controller, Service, Repository e Injeção de Dependência.', 
'# Módulo 10: Spring Boot Básico

Compreenda a arquitetura em camadas dos projetos reais da TechSoluctionsRN:
- `@RestController`
- `@Service`
- `@Repository`', 10);

-- Modulos para Trilha 2 (Java Pleno)
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(11, 2, 'Generics e Records no Java Moderno', 
'Parametrização de tipos com Generics (`<T>`) e criação de Data Transfer Objects imutáveis com `record`.', 
'# Módulo 1 (Pleno): Generics & Records

## 1. Java Records (Java 14+)
```java
public record UsuarioDTO(String nome, String email) {}
```', 1),

(12, 2, 'Sealed Classes e Interfaces', 
'Restringindo a hierarquia de herança com a palavra-chave `sealed` e `permits`.', 
'# Módulo 2 (Pleno): Sealed Classes

```java
public sealed class Resposta permits Sucesso, Erro {}
```', 2),

(13, 2, 'Concorrência & Virtual Threads (Java 21)', 
'Threads, ExecutorService e a revolução das Virtual Threads (Project Loom) no Java 21.', 
'# Módulo 3 (Pleno): Concorrência & Virtual Threads

```java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    executor.submit(() -> System.out.println("Executando em Virtual Thread"));
}
```', 3),

(14, 2, 'Testes Automatizados com JUnit 5 + Mockito', 
'Escrevendo testes unitários e mocks de serviços em aplicações Spring Boot.', 
'# Módulo 4 (Pleno): Testes com Mockito

```java
@ExtendWith(MockitoExtension.class)
class UsuarioServiceTest {
    @Mock
    private UsuarioRepository repository;
}
```', 4);

-- Exercícios Adicionais
INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem) VALUES
(2, 5, 'Polimorfismo com Geometria', 
'Crie uma interface `FormaGeometrica` com o método `double calcularArea()`. Crie a classe `Retangulo` que implementa essa interface e possui atributos `largura` e `altura`.', 
'public interface FormaGeometrica {
    double calcularArea();
}

class Retangulo implements FormaGeometrica {
    private double largura;
    private double altura;

    public Retangulo(double largura, double altura) {
        this.largura = largura;
        this.altura = altura;
    }

    @Override
    public double calcularArea() {
        // Implemente aqui
        return 0.0;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class FormasTest {
    @Test
    public void testAreaRetangulo() {
        FormaGeometrica r = new Retangulo(5.0, 4.0);
        assertEquals(20.0, r.calcularArea(), 0.001);
    }
}', 1),

(3, 6, 'Filtragem com Lists', 
'Crie uma classe publica `FiltroNumeros` com um método estático `filtrarPares(List<Integer> numeros)` que retorne uma nova lista contendo apenas os números pares.', 
'import java.util.*;

public class FiltroNumeros {
    public static List<Integer> filtrarPares(List<Integer> numeros) {
        // Implemente a filtragem aqui
        return new ArrayList<>();
    }
}',
'import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

public class FiltroTest {
    @Test
    public void testFiltrarPares() {
        List<Integer> entrada = List.of(1, 2, 3, 4, 5, 6);
        List<Integer> resultado = FiltroNumeros.filtrarPares(entrada);
        assertEquals(List.of(2, 4, 6), resultado);
    }
}', 1);
