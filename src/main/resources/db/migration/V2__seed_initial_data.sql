-- Insert Usuarios (Senhas criptografadas com BCrypt: admin123 e aluno123)
INSERT INTO usuarios (nome, email, senha, papel) VALUES 
('Adrian Gonçalves Lopes', 'adrian@techsoluctionsrn.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'ADMIN'),
('Julio Cesar', 'julio@techsoluctionsrn.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'ADMIN');

-- Insert Trilhas
INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES 
(1, 'Java Júnior (Fundamentos)', 'Aprenda do zero a sintaxe do Java, Programação Orientada a Objetos, Coleções e Introdução ao Spring Boot.', 'JUNIOR', 1),
(2, 'Java Pleno (Intermediário)', 'Conceitos avançados: Generics, Concorrência, Streams, Testes Unitários e Spring Boot REST & Security.', 'PLENO', 2);

-- Insert Modulos da Trilha 1 (Java Júnior)
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(1, 1, 'Sintaxe Básica, Tipos Primitivos e Operadores', 
'Entenda como o Java funciona, como declarar variáveis, tipos de dados primitivos (int, double, boolean) e operadores aritméticos.', 
'# Módulo 1: Sintaxe Básica e Tipos Primitivos

Bem-vindo ao primeiro módulo! Aqui vamos entender os fundamentos do Java.

## 1. Tipos Primitivos no Java
O Java possui 8 tipos primitivos principais:
- `byte` (8 bits)
- `short` (16 bits)
- `int` (32 bits)
- `long` (64 bits)
- `float` (32 bits com ponto flutuante)
- `double` (64 bits com ponto flutuante)
- `boolean` (`true` ou `false`)
- `char` (caractere único Unicode)

## 2. Declarando Variáveis
```java
int idade = 25;
double salario = 3500.50;
boolean ativo = true;
char inicial = ''A'';
```

## 3. Operadores Aritméticos
- Adição: `+`
- Subtração: `-`
- Multiplicação: `*`
- Divisão: `/`
- Módulo (resto da divisão): `%`

---
### Exercício Prático
Crie uma classe `CalculadoraSimples` com um método `somar(int a, int b)` que retorne a soma de dois números inteiros.', 1),

(2, 1, 'Estruturas de Controle', 
'Aprenda a controlar o fluxo da aplicação com if/else, switch expression e estruturas de repetição (for, while, do-while).', 
'# Módulo 2: Estruturas de Controle

## 1. Estruturas Condicionais: `if`, `else if`, `else`
```java
if (nota >= 7.0) {
    System.out.println("Aprovado");
} else if (nota >= 5.0) {
    System.out.println("Recuperação");
} else {
    System.out.println("Reprovado");
}
```

## 2. Switch (Java moderno)
```java
String diaTexto = switch (dia) {
    case 1 -> "Domingo";
    case 2 -> "Segunda-feira";
    default -> "Dia inválido";
};
```

## 3. Laços de Repetição
```java
for (int i = 0; i < 5; i++) {
    System.out.println("Passo: " + i);
}
```', 2),

(3, 1, 'Arrays e Strings', 
'Manipulação de estruturas lineares estáticas (Arrays) e imutabilidade de Strings em Java.', 
'# Módulo 3: Arrays e Strings

## 1. Arrays Unidimensionais
```java
int[] numeros = new int[5];
numeros[0] = 10;
```

## 2. Manipulando Strings
Strings em Java são imutáveis. Métodos úteis:
- `.length()`
- `.toUpperCase()` / `.toLowerCase()`
- `.contains()`
- `.substring()`', 3),

(4, 1, 'POO Básica: Classes, Objetos e Encapsulamento', 
'Entenda o paradigma da Orientação a Objetos, criação de construtores, modificadores de acesso e métodos getters/setters.', 
'# Módulo 4: Programação Orientada a Objetos

## 1. O que é uma Classe e um Objeto?
Uma **Classe** é o molde/blueprint. Um **Objeto** é a instância concreta na memória.

## 2. Encapsulamento
Utilize atributos `private` e forneça acesso via métodos de acesso (`public`).', 4);

-- Insert Exercício do Módulo 1
INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem) VALUES
(1, 1, 'Soma de Inteiros', 
'Crie uma classe publica chamada `Calculadora` que contenha um método estático `somar(int a, int b)` retornando a soma de `a` e `b`.',
'public class Calculadora {
    public static int somar(int a, int b) {
        // Implemente sua solução aqui
        return 0;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculadoraTest {
    @Test
    public void testSomarPositivos() {
        assertEquals(15, Calculadora.somar(10, 5));
    }

    @Test
    public void testSomarNegativos() {
        assertEquals(-5, Calculadora.somar(-2, -3));
    }

    @Test
    public void testSomarComZero() {
        assertEquals(7, Calculadora.somar(7, 0));
    }
}', 1);

-- Fim da carga inicial
