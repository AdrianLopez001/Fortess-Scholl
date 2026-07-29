-- ============================================================
-- V5: Sistema Profissional de Aprendizado
-- ============================================================

-- 1. Novos campos em tabelas existentes
ALTER TABLE exercicios ADD COLUMN IF NOT EXISTS dica_hint TEXT;
ALTER TABLE exercicios ADD COLUMN IF NOT EXISTS nivel_dificuldade VARCHAR(10) DEFAULT 'MEDIUM';
ALTER TABLE exercicios ADD COLUMN IF NOT EXISTS pontos_base INT DEFAULT 100;
ALTER TABLE submissoes ADD COLUMN IF NOT EXISTS pontos_obtidos INT DEFAULT 0;
ALTER TABLE submissoes ADD COLUMN IF NOT EXISTS tentativas INT DEFAULT 1;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS xp_total INT DEFAULT 0;

-- 2. Tabela de Atividade Diária (streak tracker)
CREATE TABLE atividade_diaria (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    data DATE NOT NULL,
    exercicios_resolvidos INT DEFAULT 0,
    pontos_ganhos INT DEFAULT 0,
    CONSTRAINT uk_atividade_usuario_data UNIQUE (usuario_id, data)
);

-- 3. Tabela de Inscrição em Trilha
CREATE TABLE trilha_inscricao (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    trilha_id BIGINT NOT NULL REFERENCES trilhas(id) ON DELETE CASCADE,
    data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    percentual_atual DOUBLE PRECISION DEFAULT 0.0,
    CONSTRAINT uk_inscricao_usuario_trilha UNIQUE (usuario_id, trilha_id)
);

-- ============================================================
-- TRILHA 3: Spring Boot — API REST Profissional
-- ============================================================
INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES
(3, 'Spring Boot — API REST Profissional', 
 'Da arquitetura em camadas à segurança com JWT: construa APIs REST de nível profissional com Spring Boot 3, JPA, Bean Validation e testes de integração, do jeito que fazemos nos projetos reais da TechSoluctionsRN.',
 'PLENO', 3);

INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(15, 3, 'Arquitetura em Camadas de uma API REST',
 'Controller → Service → Repository: entenda cada camada e sua responsabilidade única.',
 '# Módulo 1: Arquitetura em Camadas no Spring Boot

## Por que Separar em Camadas?
Uma arquitetura bem definida garante que cada componente tem **uma única responsabilidade**. Isso torna o código **testável**, **manutenível** e **escalável**.

## As 3 Camadas Principais

### 1. Controller (Camada de Apresentação)
Recebe requisições HTTP e delega ao Service. **Não contém lógica de negócio.**
```java
@RestController
@RequestMapping("/api/produtos")
public class ProdutoController {
    
    private final ProdutoService service;

    // Injeção de Dependência via construtor (melhor prática)
    public ProdutoController(ProdutoService service) {
        this.service = service;
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProdutoDTO> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(service.buscarPorId(id));
    }
}
```

### 2. Service (Camada de Negócio)
Contém todas as **regras de negócio**. Orquestra repositórios, validações e transformações.
```java
@Service
public class ProdutoService {
    
    private final ProdutoRepository repository;

    public ProdutoDTO buscarPorId(Long id) {
        Produto produto = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Produto não encontrado: " + id));
        return ProdutoDTO.from(produto);
    }
}
```

### 3. Repository (Camada de Dados)
Interface que abstrai o banco de dados via Spring Data JPA.
```java
@Repository
public interface ProdutoRepository extends JpaRepository<Produto, Long> {
    List<Produto> findByNomeContainingIgnoreCase(String nome);
}
```

## Fluxo Completo
```
HTTP Request → Controller → Service → Repository → Database
HTTP Response ← Controller ← Service ← Repository ← Database
```

## Princípio SOLID Aplicado: Single Responsibility
Cada camada faz **apenas o que é sua responsabilidade**:
- Controller: HTTP
- Service: Business Logic  
- Repository: Data Access

## Dica Profissional 💡
Nunca injete um `Repository` diretamente em um `Controller`. Sempre passe pelo `Service`. Isso mantém o Controller "burro" e o Service com o controle total da lógica.', 1),

(16, 3, 'JPA e Queries Customizadas com Spring Data',
 'Derived queries, @Query com JPQL e consultas nativas para buscas avançadas.',
 '# Módulo 2: JPA e Queries Customizadas

## Spring Data JPA — Poder sem SQL Manual

### Derived Query Methods
O Spring gera SQL automaticamente pelo nome do método:
```java
// SELECT * FROM produtos WHERE nome = ?
Optional<Produto> findByNome(String nome);

// SELECT * FROM produtos WHERE preco < ? AND ativo = ?
List<Produto> findByPrecoBelowAndAtivoTrue(Double preco);

// SELECT * FROM produtos WHERE nome LIKE %?% ORDER BY preco ASC
List<Produto> findByNomeContainingIgnoreCaseOrderByPrecoAsc(String nome);
```

### @Query com JPQL (Java Persistence Query Language)
Para queries complexas, use JPQL — similar a SQL mas orientado a objetos:
```java
@Query("SELECT p FROM Produto p WHERE p.categoria.id = :catId AND p.preco BETWEEN :min AND :max")
List<Produto> buscarPorCategoriaEFaixaDePreco(
    @Param("catId") Long catId,
    @Param("min") Double min,
    @Param("max") Double max
);
```

### SQL Nativo com @Query(nativeQuery = true)
Quando precisar de SQL específico do banco:
```java
@Query(value = "SELECT * FROM produtos WHERE EXTRACT(MONTH FROM data_criacao) = :mes", nativeQuery = true)
List<Produto> buscarPorMesDeCriacao(@Param("mes") int mes);
```

### @Modifying — Operações de UPDATE e DELETE
```java
@Modifying
@Transactional
@Query("UPDATE Produto p SET p.ativo = false WHERE p.id = :id")
void desativarProduto(@Param("id") Long id);
```

## Relacionamentos JPA

### @ManyToOne — Muitos produtos para uma categoria
```java
@Entity
public class Produto {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;
}
```

### @OneToMany — Uma categoria com muitos produtos
```java
@Entity
public class Categoria {
    @OneToMany(mappedBy = "categoria", cascade = CascadeType.ALL)
    private List<Produto> produtos = new ArrayList<>();
}
```

## Anti-padrão: N+1 Problem
```java
// ❌ ERRADO: gera N+1 queries ao banco
List<Pedido> pedidos = repository.findAll();
pedidos.forEach(p -> System.out.println(p.getCliente().getNome())); // N queries extras!

// ✅ CERTO: usar JOIN FETCH ou @EntityGraph
@Query("SELECT p FROM Pedido p JOIN FETCH p.cliente")
List<Pedido> findAllWithCliente();
```', 2),

(17, 3, 'Bean Validation — Validação Profissional de Dados',
 'Validação automática com @Valid, @NotBlank, @Email, @Size e erros estruturados.',
 '# Módulo 3: Bean Validation

## Por que Validar na API?
Nunca confie em dados de entrada. Valide **antes** de processar para garantir integridade e segurança.

## Annotations de Validação
```java
public class CadastrarUsuarioRequest {

    @NotBlank(message = "Nome é obrigatório")
    @Size(min = 2, max = 100, message = "Nome deve ter entre 2 e 100 caracteres")
    private String nome;

    @NotBlank(message = "E-mail é obrigatório")
    @Email(message = "E-mail deve ter formato válido")
    private String email;

    @NotBlank(message = "Senha é obrigatória")
    @Size(min = 8, message = "Senha deve ter no mínimo 8 caracteres")
    private String senha;

    @NotNull(message = "Idade é obrigatória")
    @Min(value = 18, message = "Deve ter pelo menos 18 anos")
    @Max(value = 120, message = "Idade inválida")
    private Integer idade;

    @NotNull
    @Past(message = "Data de nascimento deve ser no passado")
    private LocalDate dataNascimento;
}
```

## Ativando a Validação no Controller
```java
@PostMapping
public ResponseEntity<UsuarioDTO> cadastrar(@Valid @RequestBody CadastrarUsuarioRequest request) {
    return ResponseEntity.status(HttpStatus.CREATED).body(service.cadastrar(request));
}
```
> O `@Valid` dispara automaticamente todas as validações do objeto.

## Tratamento Global de Erros de Validação
```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationErrors(MethodArgumentNotValidException ex) {
        Map<String, String> erros = new LinkedHashMap<>();
        ex.getBindingResult().getFieldErrors()
            .forEach(fe -> erros.put(fe.getField(), fe.getDefaultMessage()));
        return ResponseEntity.badRequest().body(erros);
    }
}
```

## Validação Customizada
Para regras específicas do negócio, crie sua própria annotation:
```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = CPFValidator.class)
public @interface CPF {
    String message() default "CPF inválido";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```', 3),

(18, 3, 'Tratamento Global de Erros com @ControllerAdvice',
 'Respostas de erro padronizadas, RFC 7807 Problem Details e logging estruturado.',
 '# Módulo 4: Tratamento Global de Erros

## O Problema
Sem tratamento adequado, sua API retorna stack traces ou mensagens inconsistentes. APIs profissionais retornam erros **padronizados** e **informativos**.

## Padrão RFC 7807 — Problem Details
```json
{
  "type": "https://api.techsoluctionsrn.com/errors/resource-not-found",
  "title": "Recurso não encontrado",
  "status": 404,
  "detail": "Usuário com ID 42 não encontrado",
  "instance": "/api/usuarios/42",
  "timestamp": "2026-07-28T00:00:00"
}
```

## Implementação com @RestControllerAdvice
```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ProblemDetail> handleNotFound(ResourceNotFoundException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
        problem.setTitle("Recurso não encontrado");
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(problem);
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ProblemDetail> handleBusiness(BusinessException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.getMessage());
        problem.setTitle("Erro de negócio");
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(problem);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ProblemDetail> handleGeneric(Exception ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, "Erro interno do servidor");
        problem.setTitle("Erro inesperado");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(problem);
    }
}
```

## Hierarquia de Exceções Customizadas
```java
// Base
public abstract class AppException extends RuntimeException {
    public AppException(String message) { super(message); }
}

// Específicas
public class ResourceNotFoundException extends AppException { ... }
public class BusinessException extends AppException { ... }
public class UnauthorizedException extends AppException { ... }
```', 4),

(19, 3, 'Paginação e Filtros Avançados',
 'Paginação server-side com Pageable, Specification Pattern e filtros dinâmicos.',
 '# Módulo 5: Paginação e Filtros

## Por que Paginar?
Retornar todos os registros de uma vez é um **erro de performance grave** em produção. Implemente sempre paginação server-side.

## Paginação com Spring Data
```java
// Controller — recebe page, size, sort como query params
@GetMapping
public ResponseEntity<Page<ProdutoDTO>> listar(
    @PageableDefault(size = 20, sort = "nome", direction = Sort.Direction.ASC) Pageable pageable) {
    return ResponseEntity.ok(service.listar(pageable));
}

// Resposta da API inclui metadata de paginação automaticamente:
// { content: [...], totalElements: 200, totalPages: 10, number: 0, size: 20 }
```

## Filtros Dinâmicos com Specification
```java
public class ProdutoSpec implements Specification<Produto> {
    private String nome;
    private Double precoMin;
    private Double precoMax;

    @Override
    public Predicate toPredicate(Root<Produto> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
        List<Predicate> predicates = new ArrayList<>();
        
        if (nome != null) predicates.add(cb.like(cb.lower(root.get("nome")), "%" + nome.toLowerCase() + "%"));
        if (precoMin != null) predicates.add(cb.greaterThanOrEqualTo(root.get("preco"), precoMin));
        if (precoMax != null) predicates.add(cb.lessThanOrEqualTo(root.get("preco"), precoMax));
        
        return cb.and(predicates.toArray(new Predicate[0]));
    }
}
```', 5),

(20, 3, 'Testes de Integração com @SpringBootTest',
 'Testando endpoints HTTP reais com TestRestTemplate e MockMvc.',
 '# Módulo 6: Testes de Integração

## Diferença: Unitário vs Integração
- **Teste Unitário**: Testa uma classe isolada com mocks (Mockito)
- **Teste de Integração**: Testa o fluxo completo (HTTP → Controller → Service → BD)

## Teste de Integração com @SpringBootTest
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Transactional // Garante rollback após cada teste
class ProdutoControllerIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void deveCriarProdutoComSucesso() {
        // Arrange
        CriarProdutoRequest request = new CriarProdutoRequest("Notebook Dell", 4500.0);
        HttpEntity<CriarProdutoRequest> entity = new HttpEntity<>(request, getAdminHeaders());

        // Act
        ResponseEntity<ProdutoDTO> response = restTemplate.postForEntity("/api/produtos", entity, ProdutoDTO.class);

        // Assert
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody().getId());
        assertEquals("Notebook Dell", response.getBody().getNome());
    }

    @Test
    void deveRetornar404ParaProdutoInexistente() {
        ResponseEntity<ProblemDetail> response = restTemplate.getForEntity("/api/produtos/999999", ProblemDetail.class);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }
}
```

## Teste com MockMvc (sem servidor real)
```java
@WebMvcTest(ProdutoController.class)
class ProdutoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProdutoService service;

    @Test
    void deveRetornarListaDeProdutos() throws Exception {
        when(service.listar(any())).thenReturn(Page.empty());
        
        mockMvc.perform(get("/api/produtos").contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray());
    }
}
```', 6),

(21, 3, 'Documentação com OpenAPI 3 / Swagger UI',
 'Gerar documentação interativa automática da API com Springdoc OpenAPI.',
 '# Módulo 7: Documentação com OpenAPI / Swagger

## Por que Documentar APIs?
APIs sem documentação são **inutilizáveis** por outros times. A documentação automatizada garante que ela fique sempre **atualizada**.

## Springdoc OpenAPI — Configuração
```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.5.0</version>
</dependency>
```

## Configuração Personalizada
```java
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("TechSoluctionsRN — API de Gestão")
                .version("v1.0")
                .description("API interna dos projetos Controll-All e MatchMind AI")
                .contact(new Contact().name("Adrian Lopes").email("adrian@techsoluctionsrn.com")))
            .addSecurityItem(new SecurityRequirement().addList("Bearer"))
            .components(new Components()
                .addSecuritySchemes("Bearer", new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP).scheme("bearer").bearerFormat("JWT")));
    }
}
```

## Documentando Endpoints
```java
@Operation(
    summary = "Buscar produto por ID",
    description = "Retorna um produto específico pelo seu identificador único"
)
@ApiResponses({
    @ApiResponse(responseCode = "200", description = "Produto encontrado"),
    @ApiResponse(responseCode = "404", description = "Produto não encontrado")
})
@GetMapping("/{id}")
public ResponseEntity<ProdutoDTO> buscarPorId(
    @Parameter(description = "ID único do produto") @PathVariable Long id) {
    return ResponseEntity.ok(service.buscarPorId(id));
}
```

## Acesso ao Swagger UI
Após adicionar a dependência, acesse: `http://localhost:8085/swagger-ui.html`', 7),

(22, 3, 'Deploy de Spring Boot na AWS com Elastic Beanstalk',
 'Empacotar o JAR, configurar AWS EB CLI e fazer o primeiro deploy na nuvem.',
 '# Módulo 8: Deploy na AWS com Elastic Beanstalk

## O que é o Elastic Beanstalk?
Uma plataforma PaaS da AWS que gerencia automaticamente: provisionamento de EC2, balanceamento de carga, auto-scaling e monitoramento.

## Pré-requisitos
- Conta AWS configurada
- AWS CLI instalado e configurado (`aws configure`)
- EB CLI instalado (`pip install awsebcli`)

## Passo a Passo

### 1. Gerar o JAR
```bash
mvn clean package -DskipTests
# Arquivo em: target/minha-api-1.0.0.jar
```

### 2. Inicializar EB CLI
```bash
eb init --platform java-21 --region us-east-1 minha-api
```

### 3. Configurar application.properties para RDS AWS
```properties
spring.datasource.url=${RDS_JDBC_URL:jdbc:h2:mem:devdb}
spring.datasource.username=${RDS_USERNAME:sa}
spring.datasource.password=${RDS_PASSWORD:}
```

### 4. Criar Ambiente e Fazer Deploy
```bash
eb create minha-api-prod --instance-type t3.small
eb deploy
eb open
```

### 5. Verificar Logs
```bash
eb logs
eb health
```

## Variáveis de Ambiente no EB
No Console AWS → Elastic Beanstalk → Configurações → Software → Propriedades de ambiente:
```
JWT_SECRET=seu-segredo-seguro-aqui
DB_PASSWORD=senha-do-banco
```

## Boas Práticas de Deploy
- Sempre use variáveis de ambiente para **segredos** (nunca hardcode)
- Configure **health check** no endpoint `/actuator/health`
- Use **RDS Multi-AZ** em produção para alta disponibilidade', 8);

-- ============================================================
-- TRILHA 4: Inglês Técnico para Devs
-- ============================================================
INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES
(4, 'Technical English for Java Developers',
 'O inglês técnico é a habilidade que separa um desenvolvedor local de um desenvolvedor global. Aprenda a ler documentação, escrever commits, participar de code reviews e comunicar-se em projetos internacionais.',
 'JUNIOR', 4);

INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(23, 4, 'Reading Technical Documentation (Javadoc & APIs)',
 'Learn to extract critical information from official documentation efficiently.',
 '# Module 1: Reading Technical Documentation

## Why English Documentation Matters
Over **95% of official documentation** for Java, Spring, AWS and all major frameworks is written **exclusively in English**. Reading it efficiently is a **core developer skill**.

## The Structure of Javadoc
```java
/**
 * Returns the element at the specified position in this list.
 *
 * @param  index index of the element to return (0-indexed)
 * @return the element at the specified position in this list
 * @throws IndexOutOfBoundsException if the index is out of range
 *         (index < 0 || index >= size())
 */
public E get(int index)
```

## Key Documentation Vocabulary
| Term | Meaning |
|------|---------|
| **Deprecated** | Old feature, will be removed in future versions |
| **Since** | Version when this feature was introduced |
| **See Also** | Related classes/methods |
| **Throws** | Exceptions this method can raise |
| **Returns** | What the method gives back |
| **Parameters** | Input values the method accepts |
| **Thread-safe** | Safe to use from multiple threads simultaneously |
| **Idempotent** | Calling multiple times produces same result |
| **Nullable** | The value can be null |

## Reading Spring Documentation — Example
> *"Marks a class as a request handler, allowing Spring MVC to dispatch HTTP requests to it. It is a specialization of @Component, allowing for implementation classes to be autodetected through classpath scanning."*

**Translation**: `@Controller` tells Spring this class handles HTTP requests. Spring finds it automatically without manual configuration.

## Practice Strategy
1. Read the **method signature** first (name, parameters, return type)
2. Read **@throws** — know what can go wrong
3. Read the **description** — one paragraph at a time
4. Look at **code examples** in the docs
5. Test it yourself immediately', 1),

(24, 4, 'Writing Clear Git Commits and Pull Requests',
 'Professional commit messages, PR descriptions and code review communication.',
 '# Module 2: Git Communication in English

## The Conventional Commits Standard
```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

### Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation changes
- **refactor**: Code restructuring without feature change
- **test**: Adding or updating tests
- **chore**: Build, dependencies or config changes

### Real Examples
```bash
# ✅ Professional commits
feat(auth): add JWT refresh token mechanism
fix(user): prevent duplicate email registration
docs(api): update Swagger UI endpoint descriptions
test(produto): add integration tests for bulk creation
refactor(service): extract payment validation to separate class

# ❌ Unprofessional commits
git commit -m "fix"
git commit -m "ajuste"
git commit -m "WIP"
git commit -m "it works now"
```

## Writing a Pull Request Description
```markdown
## Summary
Implements JWT refresh token to prevent users from being logged out 
after the 1-hour access token expiration.

## Changes Made
- Added `RefreshToken` entity with UUID token and expiration date
- New endpoint `POST /api/auth/refresh` that validates and rotates tokens
- Updated `SecurityConfig` to permit refresh endpoint without authentication

## Testing
- [ ] Unit tests for `RefreshTokenService` (5 new tests, all passing)
- [ ] Manual test: login → wait → refresh → verify new token works
- [ ] Edge case: expired refresh token returns 401

## Breaking Changes
None. The existing `/api/auth/login` response now includes `refreshToken` field.

## Related Issues
Closes #47
```', 2),

(25, 4, 'Code Review Communication in English',
 'How to give constructive feedback and respond to reviews professionally.',
 '# Module 3: Code Reviews in English

## The Purpose of Code Review
Code reviews are NOT about finding who is wrong. They are about **collective code ownership** and **knowledge transfer**.

## Giving Constructive Feedback

### The Nit/Major/Blocker Scale
```
nit: Minor style suggestion (does not block merge)
suggestion: Better approach, worth considering
concern: Potential issue, needs discussion  
blocker: Must fix before merging
```

### Real Review Comments
```
// nit: Consider extracting this to a private method for readability
private List<User> filterActiveUsers(List<User> users) { ... }

// suggestion: Using Optional here would make the null check more explicit
Optional<User> findByEmail(String email);

// blocker: This will cause a NullPointerException if the user has no address.
// Please add a null check or use Optional.ofNullable()
user.getAddress().getCity() // ← NPE risk

// Positive feedback matters too!
// Really clean approach here — much better than the previous implementation.
```

## Responding to Review Comments
```
// When you agree:
"Good catch! Fixed in the latest commit (abc1234)."

// When you need clarification:
"Could you elaborate on what you mean by ''more idiomatic''? 
I want to make sure I understand the preferred pattern."

// When you respectfully disagree:
"I considered that approach, but chose this one because [reason].
Happy to discuss if you still think the other way is better."

// When it''s complex:
"This is related to how the legacy payment system works.
Let me add a comment explaining the constraint."
```', 3),

(26, 4, 'Stack Overflow — Searching and Asking Effectively',
 'Finding answers fast and writing questions that get great answers.',
 '# Module 4: Stack Overflow Mastery

## Searching Effectively BEFORE Asking

### Search Operators
```
[spring-boot] jwt 401 unauthorized
[java] NullPointerException ArrayList
[spring-security] cors configuration not working 2024
```
> Use `[tag]` to filter by technology. Add error messages verbatim.

### Reading an Answer
1. Check the **vote count** and **accepted** checkmark
2. Check the **date** — Java/Spring answers from 2015 may use outdated APIs
3. Read the **comments** — often contain important caveats
4. Look for **multiple answers** — the accepted isn''t always the best

## Writing a Good Question

### The MCVE Principle (Minimal, Complete, Verifiable Example)
```markdown
## Problem
I''m trying to configure CORS in Spring Boot 3.2 to allow 
requests from my React frontend at localhost:3000, but all 
requests return 403 Forbidden.

## What I''ve Tried
I added @CrossOrigin to my controller, but it didn''t work for 
preflight OPTIONS requests.

## My Configuration
```java
// Current SecurityConfig
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http.csrf(csrf -> csrf.disable())
        .cors(cors -> cors.configurationSource(corsConfigurationSource()));
    // ...
}
```

## Error Message
Access to fetch at http://localhost:8080/api/data from origin 
http://localhost:3000 has been blocked by CORS policy: 
Response to preflight request doesn''t pass access control check.

## Environment
- Spring Boot 3.2.0
- Spring Security 6.2.0
- Java 21
```

## Common Mistakes When Asking
- ❌ "My code doesn''t work" (no code, no error)
- ❌ Posting 200 lines when 10 lines would demonstrate the problem
- ❌ Not mentioning versions
- ❌ Not searching first', 4),

(27, 4, 'AWS Documentation and Pricing — Reading Like a Pro',
 'Navigate AWS docs, understand pricing models and make informed architecture decisions.',
 '# Module 5: Reading AWS Documentation

## The AWS Documentation Structure
Every AWS service page has the same structure:
1. **User Guide** — Conceptual understanding and how-to guides
2. **API Reference** — Complete reference for all operations
3. **CLI Reference** — Command-line interface commands
4. **SDK Reference** — Code examples in Java, Python, etc.
5. **Release Notes** — What changed recently

## Key AWS Vocabulary
| Term | Meaning |
|------|---------|
| **Region** | Physical location of AWS datacenters (e.g., us-east-1) |
| **Availability Zone (AZ)** | Isolated datacenter within a Region |
| **On-Demand** | Pay per use, no commitment |
| **Reserved Instance** | 1-3 year commitment, up to 72% discount |
| **Serverless** | No server management, pay only for execution |
| **High Availability** | System stays up even if a component fails |
| **Multi-AZ** | Running in multiple AZs for redundancy |
| **Throughput** | Amount of data processed per second |
| **Latency** | Time to get a response |
| **SLA** | Service Level Agreement — AWS uptime guarantees |

## Reading Pricing Pages
AWS pricing has 3 main models:
```
1. On-Demand: 
   EC2 t3.small = $0.0208/hour = ~$15/month
   
2. Reserved (1 year):
   Same EC2 = ~$0.013/hour = ~$9.50/month (35% savings)
   
3. Spot Instances:
   Up to 90% discount, but AWS can terminate at 2-min notice
   (Good for batch processing, bad for web servers)
```

## Reading Architecture Diagrams
AWS reference architectures always show:
- **→ arrows**: data or request flow
- **Dashed borders**: VPC/security boundaries  
- **Locks**: IAM permissions required
- **Cylinders**: Databases
- **Cloud symbol**: Internet connectivity', 5),

(28, 4, 'Stand-up Meetings and Technical Interviews in English',
 'Communicate your work clearly in daily stand-ups, retrospectives and technical interviews.',
 '# Module 6: Professional Communication

## The Daily Stand-up Format
```
Yesterday: "Yesterday I implemented the JWT refresh token endpoint and wrote unit tests."
Today: "Today I''m going to fix the CORS issue blocking the frontend and 
        start the user pagination feature."
Blockers: "I have a blocker — the staging database is down and I need 
          access to test the changes."
```

## Technical Interview Vocabulary

### When Explaining Code
- "I chose this approach because..."
- "The trade-off here is..."
- "This could be optimized by..."
- "I would refactor this if I had more time by..."
- "This is a temporary solution — the production approach would be..."

### When You Don''t Know Something
```
✅ "I''m not familiar with that specific tool, but I''ve worked with 
    similar alternatives like X, and I can learn quickly."

✅ "I don''t know the exact syntax off the top of my head, but I know 
    the concept. I would look it up in the documentation and implement it."

❌ "I don''t know." (and silence)
```

### Describing Architecture
> "Our system uses a microservices architecture where each service 
> communicates via REST APIs. We use Spring Boot for the backend, 
> PostgreSQL as our primary database, and we deploy on AWS using 
> Elastic Beanstalk. For authentication, we implemented JWT with 
> refresh tokens to maintain secure sessions."

## Pull Request Review Phrases
| Situation | Phrase |
|-----------|--------|
| Approving | "LGTM! (Looks Good To Me)" |
| Minor fix | "Could you address this nit before merging?" |
| Needs work | "This needs some changes before it''s ready." |
| Question | "Could you explain the rationale behind this approach?" |
| Compliment | "Nice clean implementation!" |', 6);

-- ============================================================
-- TRILHA 5: AWS Cloud para Desenvolvedores Java
-- ============================================================
INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES
(5, 'AWS Cloud para Desenvolvedores Java',
 'Do zero ao deploy em produção na AWS: EC2, RDS, S3, Elastic Beanstalk e CloudWatch integrados com Spring Boot. Aprenda como implantamos os projetos Controll-All e MatchMind AI na infraestrutura cloud.',
 'PLENO', 5);

INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(29, 5, 'AWS Essentials: IAM, Regiões e Console',
 'Conceitos fundamentais de cloud: regiões, zonas de disponibilidade, IAM e política do menor privilégio.',
 '# Módulo 1: AWS Essentials

## Por que AWS?
A AWS domina **32% do mercado de cloud computing** global. Dominar AWS é um diferencial de mercado que pode **dobrar seu salário** como desenvolvedor Java.

## Conceitos Fundamentais

### Regiões e Zonas de Disponibilidade
```
Região: us-east-1 (Norte da Virgínia) — região mais barata
  ├── AZ: us-east-1a (Datacenter físico A)
  ├── AZ: us-east-1b (Datacenter físico B)  
  └── AZ: us-east-1c (Datacenter físico C)

Região: sa-east-1 (São Paulo) — menor latência para clientes BR
  ├── AZ: sa-east-1a
  └── AZ: sa-east-1b
```

## IAM — Identity and Access Management

### O Princípio do Menor Privilégio
Dê **apenas as permissões necessárias** para cada usuário/serviço.

### Tipos de Identidades IAM
| Tipo | Uso |
|------|-----|
| **Root User** | Nunca use no dia a dia. Apenas para billing |
| **IAM User** | Desenvolvedor humano que acessa o console |
| **IAM Role** | Serviço AWS assumindo permissões (EC2 acessando S3) |
| **IAM Policy** | Documento JSON que define permissões |

### Policy de Exemplo (S3 Read-Only)
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["s3:GetObject", "s3:ListBucket"],
    "Resource": ["arn:aws:s3:::meu-bucket-app/*"]
  }]
}
```

## Serviços Core para Devs Java
| Serviço | Função |
|---------|--------|
| **EC2** | Servidor virtual (onde roda o Spring Boot) |
| **RDS** | Banco de dados gerenciado (PostgreSQL) |
| **S3** | Armazenamento de arquivos (uploads de usuário) |
| **Elastic Beanstalk** | PaaS para deploy simplificado |
| **CloudWatch** | Monitoramento e logs |
| **Route 53** | DNS e domínios |
| **ACM** | Certificados SSL/TLS gratuitos |', 1),

(30, 5, 'Conectando Spring Boot ao RDS PostgreSQL',
 'Configurar RDS, security groups, connection pooling com HikariCP e migrations com Flyway.',
 '# Módulo 2: Spring Boot + RDS PostgreSQL

## Criando o RDS na AWS

### Via Console AWS
1. RDS → Create database → PostgreSQL
2. Template: **Free Tier** (para testes) ou **Production**
3. Instance size: `db.t3.micro` (free tier)
4. Storage: 20 GB SSD
5. **IMPORTANTE**: Em "Connectivity", escolha sua VPC e habilite acesso público apenas se necessário

### Security Group — Liberando Acesso do EC2 ao RDS
```
Inbound Rule:
  Type: PostgreSQL (porta 5432)
  Source: Security Group do EC2 (não use 0.0.0.0/0 em produção!)
```

## Configuração no Spring Boot
```properties
# application-prod.properties
spring.datasource.url=${RDS_JDBC_URL}
spring.datasource.username=${RDS_USERNAME}
spring.datasource.password=${RDS_PASSWORD}
spring.datasource.driver-class-name=org.postgresql.Driver

# HikariCP Connection Pool
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

# Flyway rodará automaticamente ao iniciar
spring.flyway.enabled=true
```

## Obtendo o JDBC URL do RDS
```
Formato: jdbc:postgresql://<endpoint>:5432/<database>

Exemplo: jdbc:postgresql://meu-banco.abc123.us-east-1.rds.amazonaws.com:5432/producao
```

## Variáveis de Ambiente no EC2/EB
```bash
export RDS_JDBC_URL="jdbc:postgresql://..."
export RDS_USERNAME="appuser"
export RDS_PASSWORD="senha-forte-aqui"
java -jar minha-api.jar
```

## Boas Práticas de Segurança
- Nunca coloque credentials no `application.properties` versionado
- Use **AWS Secrets Manager** para armazenar e rotacionar senhas automaticamente
- Habilite **encryption at rest** no RDS
- Configure **automated backups** (retenção de 7 dias mínimo)', 2),

(31, 5, 'S3 para Upload de Arquivos com Java SDK',
 'Fazer upload/download de arquivos no S3 com AWS SDK for Java v2 dentro de um Spring Boot.',
 '# Módulo 3: S3 com Java SDK v2

## Configurando o AWS SDK v2
```xml
<!-- pom.xml -->
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
    <version>2.25.0</version>
</dependency>
```

## Configuração do S3Client
```java
@Configuration
public class AwsConfig {

    @Value("${aws.region:us-east-1}")
    private String region;

    @Bean
    public S3Client s3Client() {
        return S3Client.builder()
            .region(Region.of(region))
            .credentialsProvider(DefaultCredentialsProvider.create())
            .build();
    }
}
```

## Service de Upload
```java
@Service
public class S3UploadService {

    private final S3Client s3Client;

    @Value("${aws.s3.bucket}")
    private String bucket;

    public String uploadArquivo(String chave, InputStream arquivo, long tamanho, String contentType) {
        PutObjectRequest request = PutObjectRequest.builder()
            .bucket(bucket)
            .key(chave)
            .contentType(contentType)
            .contentLength(tamanho)
            .build();

        s3Client.putObject(request, RequestBody.fromInputStream(arquivo, tamanho));

        return String.format("https://%s.s3.amazonaws.com/%s", bucket, chave);
    }

    public void deletarArquivo(String chave) {
        s3Client.deleteObject(b -> b.bucket(bucket).key(chave));
    }

    public URL gerarUrlTemporaria(String chave, int minutosValidade) {
        GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
            .signatureDuration(Duration.ofMinutes(minutosValidade))
            .getObjectRequest(r -> r.bucket(bucket).key(chave))
            .build();

        PresignedGetObjectRequest presigned = S3Presigner.create().presignGetObject(presignRequest);
        return presigned.url();
    }
}
```

## Estrutura de Chaves no S3 (Boas Práticas)
```
uploads/
  usuarios/
    {userId}/
      profile-{uuid}.jpg
      documents/
        cv-{uuid}.pdf
```

## Segurança
- Configure **CORS no bucket** para permitir uploads direto do browser
- Use **IAM Roles** no EC2/EB — nunca hardcode access keys no código
- Habilite **versioning** para recuperar arquivos deletados acidentalmente', 3),

(32, 5, 'CloudWatch — Monitoramento e Alertas',
 'Métricas, logs estruturados, alarmes e dashboards para APIs Spring Boot em produção.',
 '# Módulo 4: CloudWatch para APIs Java

## Por que Monitorar?
Em produção, você **não pode ficar olhando o terminal**. O monitoramento avisa você antes que o cliente perceba o problema.

## Integração Spring Boot + CloudWatch Logs

### Dependência
```xml
<dependency>
    <groupId>ca.pjer</groupId>
    <artifactId>logback-awslogs-appender</artifactId>
    <version>1.6.0</version>
</dependency>
```

### logback-spring.xml
```xml
<configuration>
    <appender name="AWS_LOGS" class="ca.pjer.logback.AwsLogsAppender">
        <logGroupName>/minha-api/producao</logGroupName>
        <logStreamUuidPrefix>api-</logStreamUuidPrefix>
        <logRegion>us-east-1</logRegion>
        <maxBatchLogEvents>50</maxBatchLogEvents>
        <maxFlushTimeMillis>30000</maxFlushTimeMillis>
    </appender>

    <root level="INFO">
        <appender-ref ref="AWS_LOGS"/>
    </root>
</configuration>
```

## Logs Estruturados com SLF4J
```java
// ❌ Log não estruturado (difícil de filtrar no CloudWatch)
log.info("Usuário criado com sucesso!");

// ✅ Log estruturado (filtrável, pesquisável)
log.info("Usuário criado: userId={}, email={}, trilhasInscritas={}", 
    usuario.getId(), usuario.getEmail(), trilhas.size());

// ✅ Log de erro com contexto completo
log.error("Erro ao processar pagamento: orderId={}, valor={}, erro={}", 
    order.getId(), order.getValor(), e.getMessage(), e);
```

## Criando Alarmes no CloudWatch
```
Alarme de Erro 5xx:
  Métrica: ApplicationRequestCount
  Filtro: response_code >= 500
  Threshold: > 10 erros em 5 minutos
  Ação: SNS → Email para time@techsoluctionsrn.com

Alarme de Memória:
  Métrica: JVMMemoryUsed  
  Threshold: > 80% da heap
  Ação: Auto-scaling trigger
```

## Dashboard Profissional no CloudWatch
Configure um dashboard com:
- Requisições por minuto (RPS)
- Latência média (p50, p95, p99)
- Taxa de erros (4xx, 5xx)
- Memória JVM utilizada
- Conexões ativas no pool do banco', 4),

(33, 5, 'Elastic Beanstalk — CI/CD com GitHub Actions',
 'Automatizar o deploy de Spring Boot na AWS via GitHub Actions pipeline.',
 '# Módulo 5: CI/CD com GitHub Actions + Elastic Beanstalk

## O que é CI/CD?
- **CI (Continuous Integration)**: Cada push roda testes automaticamente
- **CD (Continuous Deployment)**: Aprovado nos testes → deploy automático para produção

## GitHub Actions Workflow para Spring Boot
```yaml
# .github/workflows/deploy.yml
name: CI/CD — Deploy para AWS

on:
  push:
    branches: [main]

jobs:
  test-and-build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Configurar JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: ''21''
          distribution: ''temurin''
          
      - name: Executar Testes
        run: mvn clean test
        
      - name: Build do JAR
        run: mvn package -DskipTests
        
      - name: Upload Artefato
        uses: actions/upload-artifact@v4
        with:
          name: app-jar
          path: target/*.jar
          
  deploy:
    needs: test-and-build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: app-jar
          
      - name: Deploy para Elastic Beanstalk
        uses: einaregilsson/beanstalk-deploy@v22
        with:
          aws_access_key: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          region: us-east-1
          application_name: minha-api
          environment_name: minha-api-prod
          deployment_package: app.jar
```

## Configurando Secrets no GitHub
```
Repository Settings → Secrets and variables → Actions:
  AWS_ACCESS_KEY_ID = AKIA...
  AWS_SECRET_ACCESS_KEY = ...
  RDS_JDBC_URL = jdbc:postgresql://...
  JWT_SECRET = seu-segredo
```

## Estratégias de Deploy
| Estratégia | Downtime | Custo | Recomendado |
|------------|----------|-------|-------------|
| **All at once** | Sim | Baixo | Dev/Test |
| **Rolling** | Não | Médio | Staging |
| **Blue/Green** | Não | Alto | Produção |', 5),

(34, 5, 'Arquitetura Serverless com AWS Lambda + Java',
 'Functions-as-a-Service com Java 21, AWS Lambda e API Gateway para cargas de trabalho assíncronas.',
 '# Módulo 6: AWS Lambda com Java

## Quando Usar Lambda vs. EC2/EB?
| Critério | Lambda | EC2/Beanstalk |
|----------|--------|---------------|
| Custo para tráfego baixo | Muito baixo (pague por invocação) | Maior (instância sempre ligada) |
| Custo para tráfego alto | Pode ser maior | Previsível |
| Cold start | ~1-2 segundos | Zero |
| Gerenciamento | Nenhum | Baixo (EB) ou Alto (EC2) |
| Bom para | Processamento assíncrono, webhooks, ETL | APIs REST com tráfego constante |

## Criando uma Lambda em Java 21
```xml
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-lambda-java-core</artifactId>
    <version>1.2.3</version>
</dependency>
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-lambda-java-events</artifactId>
    <version>3.11.4</version>
</dependency>
```

```java
public class RelatorioHandler implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("Processando relatório: " + event.getBody());

        // Sua lógica aqui
        String relatorio = gerarRelatorio(event.getBody());

        return new APIGatewayProxyResponseEvent()
            .withStatusCode(200)
            .withBody(relatorio)
            .withHeaders(Map.of("Content-Type", "application/json"));
    }
}
```

## Casos de Uso Reais no TechSoluctionsRN
- **Geração de relatórios PDF** em background (não bloqueia a API)
- **Processamento de imagens** ao fazer upload no S3
- **Envio de emails em lote** via Amazon SES
- **Sincronização de dados** com sistemas externos (Controll-All)

## Deploy da Lambda
```bash
# Empacotar como fat JAR
mvn clean package shade:shade

# Deploy via AWS CLI
aws lambda create-function \
  --function-name relatorio-handler \
  --runtime java21 \
  --handler com.techsoluctionsrn.RelatorioHandler::handleRequest \
  --zip-file fileb://target/lambda.jar \
  --role arn:aws:iam::123456789:role/lambda-execution-role \
  --timeout 30 \
  --memory-size 512
```', 6);

-- ============================================================
-- EXERCÍCIOS PROFISSIONAIS — Trilha Spring Boot
-- ============================================================
INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES

-- Módulo 15: Arquitetura em Camadas
(10, 15, 'Implementar um Service com Validação de Negócio',
'Implemente a classe `ContaService` com o método `sacar(double valor)`. Regras:
1. O saldo inicial é R$1000,00
2. Se o valor for <= 0, lance IllegalArgumentException("Valor inválido")
3. Se o saldo for insuficiente, lance IllegalStateException("Saldo insuficiente")  
4. Se válido, debite do saldo e retorne o novo saldo',
'public class ContaService {
    private double saldo = 1000.0;

    public double sacar(double valor) {
        // TODO: Implemente as validações e o saque
        return saldo;
    }

    public double getSaldo() {
        return saldo;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ContaServiceTest {
    @Test
    public void testSaqueValido() {
        ContaService service = new ContaService();
        double novoSaldo = service.sacar(300.0);
        assertEquals(700.0, novoSaldo, 0.001);
    }

    @Test
    public void testSaldoInsuficiente() {
        ContaService service = new ContaService();
        assertThrows(IllegalStateException.class, () -> service.sacar(1500.0));
    }

    @Test
    public void testValorInvalido() {
        ContaService service = new ContaService();
        assertThrows(IllegalArgumentException.class, () -> service.sacar(0));
        assertThrows(IllegalArgumentException.class, () -> service.sacar(-100));
    }
}', 1, 'MEDIUM', 100, 'Pense nas validações em ordem: primeiro valide o valor recebido (<=0), depois compare com o saldo disponível. Use if() e throw new ExceçãoTipo("mensagem").'),

-- Módulo 16: JPA Queries
(11, 16, 'Filtro de Produtos por Faixa de Preço (Stream + Filter)',
'Implemente `ProdutoRepository` com o método `filtrarPorFaixaDePreco(List<Produto> produtos, double min, double max)` que retorna apenas os produtos cujo preço está na faixa especificada (inclusivo), ordenados por preço crescente.',
'import java.util.*;
import java.util.stream.*;

public class Produto {
    private String nome;
    private double preco;

    public Produto(String nome, double preco) {
        this.nome = nome;
        this.preco = preco;
    }
    public String getNome() { return nome; }
    public double getPreco() { return preco; }
}

public class ProdutoRepository {
    public List<Produto> filtrarPorFaixaDePreco(List<Produto> produtos, double min, double max) {
        // TODO: Use Streams para filtrar e ordenar
        return new ArrayList<>();
    }
}',
'import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

public class ProdutoRepositoryTest {
    @Test
    public void testFiltroFaixaDePreco() {
        ProdutoRepository repo = new ProdutoRepository();
        List<Produto> catalogo = List.of(
            new Produto("Notebook", 4500.0),
            new Produto("Mouse", 89.90),
            new Produto("Teclado", 199.90),
            new Produto("Monitor", 1200.0),
            new Produto("Headset", 350.0)
        );

        List<Produto> resultado = repo.filtrarPorFaixaDePreco(catalogo, 100.0, 1200.0);

        assertEquals(3, resultado.size());
        assertEquals("Teclado", resultado.get(0).getNome());
        assertEquals("Headset", resultado.get(1).getNome());
        assertEquals("Monitor", resultado.get(2).getNome());
    }

    @Test
    public void testFiltroSemResultados() {
        ProdutoRepository repo = new ProdutoRepository();
        List<Produto> resultado = repo.filtrarPorFaixaDePreco(List.of(new Produto("Caro", 9999.0)), 0, 100);
        assertTrue(resultado.isEmpty());
    }
}', 1, 'MEDIUM', 100, 'Use stream().filter() para aplicar os dois critérios (>= min && <= max), depois use sorted(Comparator.comparingDouble()) para ordenar. Finalize com collect(Collectors.toList()).'),

-- Módulo 17: Bean Validation
(12, 17, 'Validador de CPF Brasileiro',
'Implemente a classe `CPFValidator` com o método estático `boolean isValido(String cpf)`. O CPF deve:
1. Ter 11 dígitos (ignorando pontos e traços)
2. Não ser uma sequência repetida (111.111.111-11, etc.)
3. Passar no algoritmo de verificação dos 2 dígitos verificadores',
'public class CPFValidator {

    public static boolean isValido(String cpf) {
        // 1. Remova pontos e traços e verifique se tem 11 dígitos
        // 2. Rejeite sequências repetidas
        // 3. Calcule e valide os 2 dígitos verificadores
        return false;
    }

    private static int calcularDigito(String cpf, int tamanho) {
        // Soma ponderada dos dígitos
        int soma = 0;
        for (int i = 0; i < tamanho; i++) {
            soma += (cpf.charAt(i) - ''0'') * (tamanho + 1 - i);
        }
        int resto = (soma * 10) % 11;
        return (resto == 10 || resto == 11) ? 0 : resto;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CPFValidatorTest {
    @Test
    public void testCPFValidoComMascara() {
        assertTrue(CPFValidator.isValido("529.982.247-25"));
    }

    @Test
    public void testCPFValidoSemMascara() {
        assertTrue(CPFValidator.isValido("52998224725"));
    }

    @Test
    public void testCPFInvalidoSequenciaRepetida() {
        assertFalse(CPFValidator.isValido("111.111.111-11"));
        assertFalse(CPFValidator.isValido("000.000.000-00"));
    }

    @Test
    public void testCPFInvalidoDigitoVerificador() {
        assertFalse(CPFValidator.isValido("529.982.247-26")); // dígito errado
    }

    @Test
    public void testCPFInvalidoTamanho() {
        assertFalse(CPFValidator.isValido("123456"));
        assertFalse(CPFValidator.isValido(""));
        assertFalse(CPFValidator.isValido(null));
    }
}', 1, 'HARD', 150, 'O algoritmo de validação do CPF: 1) Pegue os 9 primeiros dígitos. 2) Multiplique cada dígito por pesos decrescentes (10,9,8...2). 3) Some e calcule: (soma*10)%11. Se >9, o dígito é 0. Repita para o 10° dígito com pesos 11,10...3.');

-- Exercícios para módulos de Inglês Técnico
INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(13, 23, 'Parse a Javadoc Comment',
'Read the javadoc below and implement the `calcularMedia` method exactly as specified: it receives a non-empty int array and returns the arithmetic mean as a double. Throw IllegalArgumentException if the array is null or empty.',
'/**
 * Calculates the arithmetic mean of all elements in the array.
 *
 * @param  numeros the array of integers to average (must not be null or empty)
 * @return the arithmetic mean as a double value
 * @throws IllegalArgumentException if numeros is null or has length 0
 */
public class MathUtils {
    public static double calcularMedia(int[] numeros) {
        // Read the javadoc above and implement accordingly
        return 0.0;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class MathUtilsTest {
    @Test
    public void testMediaBasica() {
        assertEquals(3.0, MathUtils.calcularMedia(new int[]{1, 2, 3, 4, 5}), 0.001);
    }

    @Test
    public void testMediaComFracao() {
        assertEquals(2.5, MathUtils.calcularMedia(new int[]{1, 2, 3, 4}), 0.001);
    }

    @Test
    public void testArrayNuloLancaExcecao() {
        assertThrows(IllegalArgumentException.class, () -> MathUtils.calcularMedia(null));
    }

    @Test
    public void testArrayVazioLancaExcecao() {
        assertThrows(IllegalArgumentException.class, () -> MathUtils.calcularMedia(new int[]{}));
    }
}', 1, 'EASY', 80, 'The @throws tag tells you exactly when to throw the exception. Sum all elements with a for loop and divide by the array length. Remember integer division truncates — cast to double first!');

-- Exercícios para trilha AWS
INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(14, 29, 'Calculadora de Custo AWS EC2',
'Implemente a classe `AwsCostCalculator` com o método `calcularCustoMensal(String instanceType, int horasPorDia)` que calcula o custo mensal de uma instância EC2. Preços (por hora):
- "t3.micro": $0.0104
- "t3.small": $0.0208  
- "t3.medium": $0.0416
- "m5.large": $0.096
Lance IllegalArgumentException para tipo desconhecido ou horas inválidas (<=0 ou >24).',
'public class AwsCostCalculator {

    private static final java.util.Map<String, Double> PRECOS = new java.util.HashMap<>();

    static {
        PRECOS.put("t3.micro", 0.0104);
        PRECOS.put("t3.small", 0.0208);
        PRECOS.put("t3.medium", 0.0416);
        PRECOS.put("m5.large", 0.096);
    }

    public static double calcularCustoMensal(String instanceType, int horasPorDia) {
        // Valide os parâmetros e calcule: precoHora * horasPorDia * 30
        return 0.0;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AwsCostCalculatorTest {
    @Test
    public void testT3MicroRodando24Horas() {
        double custo = AwsCostCalculator.calcularCustoMensal("t3.micro", 24);
        assertEquals(7.488, custo, 0.001); // 0.0104 * 24 * 30
    }

    @Test
    public void testM5LargeRodando8Horas() {
        double custo = AwsCostCalculator.calcularCustoMensal("m5.large", 8);
        assertEquals(23.04, custo, 0.001); // 0.096 * 8 * 30
    }

    @Test
    public void testTipoDesconhecido() {
        assertThrows(IllegalArgumentException.class, () -> AwsCostCalculator.calcularCustoMensal("z99.xlarge", 24));
    }

    @Test
    public void testHorasInvalidas() {
        assertThrows(IllegalArgumentException.class, () -> AwsCostCalculator.calcularCustoMensal("t3.micro", 0));
        assertThrows(IllegalArgumentException.class, () -> AwsCostCalculator.calcularCustoMensal("t3.micro", 25));
    }
}', 1, 'EASY', 80, 'Use PRECOS.containsKey() para verificar se o tipo existe. O custo mensal = precoHora * horasPorDia * 30. Atenção: valide horas ANTES de calcular.');

-- Exercícios extras para módulos Junior existentes
INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES

(15, 1, 'Conversor de Temperatura',
'Implemente a classe `ConversorTemperatura` com dois métodos:
- `celsiusParaFahrenheit(double c)` → retorna (c × 9/5) + 32
- `fahrenheitParaCelsius(double f)` → retorna (f - 32) × 5/9',
'public class ConversorTemperatura {

    public static double celsiusParaFahrenheit(double celsius) {
        // Implemente a conversão C → F
        return 0.0;
    }

    public static double fahrenheitParaCelsius(double fahrenheit) {
        // Implemente a conversão F → C
        return 0.0;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ConversorTemperaturaTest {
    @Test
    public void testAgua_FervePontoEmFahrenheit() {
        assertEquals(212.0, ConversorTemperatura.celsiusParaFahrenheit(100.0), 0.001);
    }

    @Test
    public void testZeroGraus_EmFahrenheit() {
        assertEquals(32.0, ConversorTemperatura.celsiusParaFahrenheit(0.0), 0.001);
    }

    @Test
    public void testCorpoHumano_ConversoInversa() {
        assertEquals(37.0, ConversorTemperatura.fahrenheitParaCelsius(98.6), 0.001);
    }
}', 2, 'EASY', 80, 'Use a fórmula exata: C→F = (celsius * 9.0/5.0) + 32. Cuidado com divisão inteira! Use 9.0/5.0 ou 9.0/5 para garantir divisão de ponto flutuante.'),

(16, 2, 'Jogo FizzBuzz Profissional',
'Implemente `FizzBuzz.jogar(int n)` que retorna uma List<String> com N elementos:
- Múltiplo de 3 AND 5 → "FizzBuzz"
- Múltiplo de 3 → "Fizz"
- Múltiplo de 5 → "Buzz"
- Outros → o número como String',
'import java.util.*;

public class FizzBuzz {
    public static List<String> jogar(int n) {
        // Construa a lista com n elementos seguindo as regras
        return new ArrayList<>();
    }
}',
'import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

public class FizzBuzzTest {
    @Test
    public void testPrimeiros15Elementos() {
        List<String> resultado = FizzBuzz.jogar(15);
        assertEquals("1", resultado.get(0));
        assertEquals("2", resultado.get(1));
        assertEquals("Fizz", resultado.get(2));   // 3
        assertEquals("Buzz", resultado.get(4));   // 5
        assertEquals("Fizz", resultado.get(8));   // 9
        assertEquals("Buzz", resultado.get(9));   // 10
        assertEquals("FizzBuzz", resultado.get(14)); // 15
    }

    @Test
    public void testTamanhoCorreto() {
        assertEquals(20, FizzBuzz.jogar(20).size());
    }
}', 2, 'EASY', 80, 'A ordem das condições importa! Verifique divisão por 15 (ou 3 AND 5) PRIMEIRO, depois 3, depois 5. Use n % 3 == 0 para verificar divisibilidade.'),

(17, 7, 'Calculadora com Tratamento de Exceção',
'Implemente `Calculadora.dividir(double a, double b)`. Se b == 0, lance ArithmeticException("Divisão por zero não permitida"). Caso contrário, retorne a divisão.',
'public class Calculadora {
    public static double dividir(double a, double b) {
        // Lance ArithmeticException se b == 0
        return 0.0;
    }
}',
'import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculadoraTest {
    @Test
    public void testDivisaoNormal() {
        assertEquals(2.5, Calculadora.dividir(10.0, 4.0), 0.001);
        assertEquals(-3.0, Calculadora.dividir(-9.0, 3.0), 0.001);
    }

    @Test
    public void testDivisaoPorZero() {
        ArithmeticException ex = assertThrows(ArithmeticException.class, () -> Calculadora.dividir(10.0, 0));
        assertEquals("Divisão por zero não permitida", ex.getMessage());
    }
}', 2, 'EASY', 80, 'Use uma condição simples: if (b == 0) throw new ArithmeticException("mensagem exata aqui"); Depois retorne a / b normalmente.'),

(18, 8, 'Pipeline Funcional com Streams',
'Implemente `StreamPipeline.processarNomes(List<String> nomes)` que:
1. Filtre nomes com mais de 3 letras
2. Converta para uppercase
3. Ordene alfabeticamente
4. Retorne os 3 primeiros resultados (ou menos se houver menos de 3)',
'import java.util.*;
import java.util.stream.*;

public class StreamPipeline {
    public static List<String> processarNomes(List<String> nomes) {
        // Use stream pipeline: filter → map → sorted → limit → collect
        return new ArrayList<>();
    }
}',
'import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

public class StreamPipelineTest {
    @Test
    public void testPipelineCompleto() {
        List<String> entrada = List.of("Ana", "Joao", "Carlos", "Ze", "Bruno", "Marcos", "Li");
        List<String> resultado = StreamPipeline.processarNomes(entrada);
        assertEquals(3, resultado.size());
        assertEquals(List.of("BRUNO", "CARLOS", "JOAO"), resultado);
    }

    @Test
    public void testListaComPoucosResultados() {
        List<String> entrada = List.of("Ana", "Ze", "Li", "Jo");
        List<String> resultado = StreamPipeline.processarNomes(entrada);
        // Apenas "Jo" passa pelo filtro (>3 letras = nenhum... todos tem <=3), resultado vazio
        // "Ana", "Ze", "Li" = <=3 chars, "Jo" = 2 chars
        assertEquals(0, resultado.size());
    }
}', 1, 'MEDIUM', 100, 'Construa o pipeline passo a passo: .stream().filter(n -> n.length() > 3).map(String::toUpperCase).sorted().limit(3).collect(Collectors.toList()). Cada operação é encadeada.');
