# ⚡ TechSoluctionsRN — Java & Network Academy (Fortress-School)

> **Plataforma Web de Capacitação Técnica e Aprendizado Interativo (Júnior → Pleno → Sênior)**  
> *Ambiente corporativo de estudo com sandbox multilingue em tempo real, compilação de código Java e Python, suíte de testes automatizados, quizzes teóricos, gamificação e emissão de certificados oficiais.*

[![Java 21](https://img.shields.io/badge/Java-21-orange.svg)](https://oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.4-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Python 3.9](https://img.shields.io/badge/Python-3.9-blue.svg)](https://python.org/)
[![JUnit 5](https://img.shields.io/badge/JUnit-5-red.svg)](https://junit.org/junit5/)
[![Flyway](https://img.shields.io/badge/Flyway-Migration-red.svg)](https://flywaydb.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](#)

---

## 🎯 Visão Geral

O **Fortress-School (TechSoluctionsRN Academy)** é uma plataforma web desenvolvida para nivelar, acelerar e elevar o padrão técnico dos colaboradores em **Java, Spring Boot, Algoritmos, Engenharia de Redes com Python, Inglês Técnico e AWS Cloud**.

Em vez de videoaulas passivas, o aprendizado é **100% mão na massa**: em cada módulo, o aluno estuda a teoria em Markdown e resolve **exercícios práticos escrevendo código diretamente no navegador** via Monaco Editor (o mesmo editor do VS Code), com validação instantânea através de testes unitários executados em um sandbox de servidor isolado.

---

## ✨ Principais Funcionalidades

### 1. 💻 Sandbox Multilingue de Execução em Tempo Real (Java & Python)
- **Java Compiler (`javax.tools`) + JUnit 5:** Compila o código Java enviado pelo aluno e executa os testes unitários via `JUnit Platform Launcher` em um subprocesso de tempo limite seguro.
- **Python Runner (`python3 unittest`):** Executa scripts em Python para automação de redes e scripts de infraestrutura.
- **Detecção Automática:** O editor alterna a linguagem do Monaco Editor (Java / Python) e a suíte de testes de acordo com o exercício selecionado.

### 2. 🔍 Feedback Pedagógico Inteligente & Dicas Contextuais
- **Parser Visual de Assertion:** Transforma saídas brutas do terminal em cartões de erro amigáveis mostrando o teste que falhou, o valor **Esperado vs Recebido** e a linha exata do erro no código.
- **Dicas Progressivas (Hints):** A partir da 2ª tentativa falha em um exercício, o sistema fornece uma dica pedagógica contextual para destravar o aluno.

### 3. 🎮 Sistema Gamificado de Aprendizado
- **XP e Streaks:** O aluno ganha experiência (XP) ao resolver exercícios e mantém sua ofensiva diária de estudos.
- **Regra de Progresso (70%):** O próximo módulo só é liberado quando o aluno conclui no mínimo 70% dos exercícios do módulo atual.
- **🏆 Certificados Autenticáveis:** Ao concluir uma trilha, o aluno pode emitir seu certificado oficial com código hash único de validação.

### 4. 📊 Painel do Líder Técnico (Admin Dashboard)
- Acompanhamento do progresso da equipe em tempo real (módulos concluídos, exercícios resolvidos e percentual de avanço).
- Gestão e cadastro de novos colaboradores.

---

## 🚀 Trilhas de Aprendizado (8 Trilhas & 54 Módulos)

| # | Trilha | Nível | Foco Principal | Módulos |
|---|---|---|---|---|
| **1** | **Java Júnior** | `JUNIOR` | Sintaxe, POO, Estruturas de Controle, Coleções, Exceções e Git | 10 |
| **2** | **Java Pleno** | `PLENO` | Generics, Records, Sealed Classes, Streams, Virtual Threads (Java 21) | 4 |
| **3** | **Spring Boot API REST** | `PLENO` | Controller-Service-Repository, JPA, Validation, DTOs, Security, Swagger, Docker | 10 |
| **4** | **Technical English** | `JUNIOR` | Leitura de Javadoc, escrita de PRs, Stack Overflow e reuniões de Stand-up | 6 |
| **5** | **AWS Cloud para Java** | `PLENO` | IAM, RDS PostgreSQL, S3 SDK, CloudWatch, Beanstalk e Serverless Lambda | 6 |
| **6** | **Entendendo Algoritmos** | `PLENO` | *Baseado no livro de Aditya Bhargava:* Pesquisa Binária, Selection Sort, QuickSort, Hash, BFS, DP | 7 |
| **7** | **Java Como Programar** | `PLENO` | *Baseado no livro de Paul Deitel (10ª ed.):* Herança, Interfaces, Exceptions, Generics, Concurrent Threads, JDBC | 7 |
| **8** | **NetWatch — Redes & Python** | `PLENO` | *Projeto Evolutivo NetWatch:* Sockets TCP/IP, SSH CLI Automation, Scapy, RESTCONF/YANG, Port Scanner, Alertas | 6 |

---

## 🛠️ Arquitetura e Tecnologias

### Backend
- **Linguagem:** Java 21 (LTS)
- **Framework:** Spring Boot 3.3.4 (Spring Web, Spring Security, Spring Data JPA, Validation)
- **Segurança:** Autenticação via JWT (JSON Web Tokens)
- **Banco de Dados:** H2 In-Memory (Dev/Test) com scripts de migração automática via **Flyway** (`V1` a `V7`)
- **Sandbox Container:** Subprocessos isolados para `javac`, `JUnit 5` e `python3 unittest`

### Frontend
- **Interface:** HTML5 + Vanilla CSS3 (Design System moderno com Glassmorphism, Dark Mode e animações)
- **Code Editor:** Monaco Editor (`monaco-editor` v0.44) com suporte a Java e Python
- **Markdown Renderer:** Marked.js para renderização das aulas teóricas
- **UI Components:** Toast animado de XP, terminal estruturado de testes, quizzes teóricos e modal de certificados

---

## 💻 Como Executar o Projeto Localmente

### Pré-requisitos
- **Java JDK 21** instalado e configurado no `PATH`
- **Apache Maven 3.9+**
- **Python 3.9+** (opcional, para executar a Trilha de Redes NetWatch)

### Passo a Passo

1. **Clonar o Repositório:**
   ```bash
   git clone https://github.com/AdrianLopez001/Fortess-Scholl.git
   cd Fortess-Scholl
   ```

2. **Compilar e Executar os Testes Unitários:**
   ```bash
   mvn clean test
   ```

3. **Iniciar a Aplicação Spring Boot:**
   ```bash
   mvn spring-boot:run
   ```

4. **Acessar a Plataforma:**
   Abra o navegador e acesse: [http://localhost:8085](http://localhost:8085)

---

## 🔑 Credenciais Rápidas de Acesso (Ambiente de Demonstração)

A plataforma conta com atalhos de **Acesso Rápido** na tela inicial de login:

| Papel | Nome | E-mail | Senha |
|---|---|---|---|
| 👑 **Líder Técnico (Admin)** | Adrian Lopes | `adrian@techsoluctionsrn.com` | `admin123` |
| 👑 **Líder Técnico (Admin)** | Julio Cesar | `julio@techsoluctionsrn.com` | `admin123` |

---

## 📁 Estrutura do Projeto

```
Fortess-Scholl/
├── src/
│   ├── main/
│   │   ├── java/com/techsoluctionsrn/plataforma_ensino_java/
│   │   │   ├── config/          # Spring Security, JWT & Beans
│   │   │   ├── controller/      # REST Controllers (Auth, Trilhas, Submissões, Certificados, Admin)
│   │   │   ├── domain/          # Entidades JPA (Trilha, Modulo, Exercicio, Quiz, Usuario, Submissao)
│   │   │   ├── dto/             # Objetos de Transferência de Dados (DTOs)
│   │   │   ├── repository/       # Repositórios Spring Data JPA
│   │   │   └── service/         # Serviços de Negócio e Execução Sandbox (ExerciseRunnerService)
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── db/migration/    # Scripts de Migração Flyway (V1__init a V7__netwatch)
│   │       └── static/          # Frontend Web (index.html, app.js, style.css)
│   └── test/                    # Suíte de Testes Automatizados JUnit
├── pom.xml
└── README.md
```

---

## 👨‍💻 Autor e Créditos

Desenvolvido por **Adrian Gonçalves Lopes**  
**TechSoluctionsRN** — Programa de Capacitação Técnica Interna.