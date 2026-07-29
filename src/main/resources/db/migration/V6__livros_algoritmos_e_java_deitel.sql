-- ============================================================
-- V6 — Conteúdo baseado nos livros:
--   "Entendendo Algoritmos" — Aditya Y. Bhargava (Grokking Algorithms)
--   "Java: Como Programar" 10ª ed. — Paul J. Deitel & Harvey Deitel
-- ============================================================
-- Flyway: spring.flyway.placeholder-replacement=false
-- IDs continuam a partir de: trilha=6, modulo=35, exercicio=50, quiz=50
-- ============================================================

-- ============================================================
-- TRILHA 6: ENTENDENDO ALGORITMOS — Aditya Y. Bhargava
-- ============================================================
INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES
(6, 'Entendendo Algoritmos — Aditya Bhargava',
 'Baseado no livro "Entendendo Algoritmos". Do Big O à programação dinâmica: pesquisa binária, recursão, quicksort, tabelas hash, grafos e muito mais. Aprenda a pensar algoritmicamente.',
 'PLENO', 6);

-- ── Módulo 6.1: Pesquisa Binária e Big O ─────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(35, 6, 'Pesquisa Binária e Notação Big O',
 'O ponto de partida de todo algoritmo eficiente: como medir desempenho.',
'# Pesquisa Binária e Notação Big O\n\n**Livro:** Entendendo Algoritmos — Cap. 1 e 2\n\n## O Problema da Busca\n\nDados uma lista **ordenada** de N elementos, como encontrar um item com o menor número de comparações?\n\n**Busca Linear** — O(n): olha elemento por elemento.\n**Pesquisa Binária** — O(log n): sempre corta o espaço ao meio.\n\n```java\npublic static int pesquisaBinaria(int[] lista, int alvo) {\n    int baixo = 0;\n    int alto  = lista.length - 1;\n\n    while (baixo <= alto) {\n        int meio = (baixo + alto) / 2;\n        if (lista[meio] == alvo)   return meio;\n        if (lista[meio] < alvo)    baixo = meio + 1;\n        else                       alto  = meio - 1;\n    }\n    return -1; // não encontrado\n}\n```\n\n## Notação Big O\n\nMede o **crescimento** do tempo de execução em relação ao tamanho da entrada N:\n\n| Notação | Nome | Exemplo |\n|---|---|---|\n| O(1) | Constante | Acesso a array por índice |\n| O(log n) | Logarítmico | Pesquisa Binária |\n| O(n) | Linear | Busca linear |\n| O(n log n) | Quasi-linear | MergeSort, QuickSort |\n| O(n²) | Quadrático | Selection Sort |\n| O(2ⁿ) | Exponencial | Torres de Hanói |\n\n> **Regra de ouro:** Big O descreve o **pior caso** e ignora constantes.\n\n## Por que O(log n) é tão rápido?\n\n- Lista com 128 elementos → no máximo **7** comparações\n- Lista com 4 bilhões → no máximo **32** comparações\n\nEssa é a mágica de dividir o problema ao meio a cada passo.',
 1);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(50, 35,
 'Pesquisa Binária',
 'Implemente o algoritmo de pesquisa binária. Dado um array de inteiros ORDENADO e um valor alvo, retorne o ÍNDICE onde o alvo está, ou -1 se não encontrado. Complexidade esperada: O(log n).',
'public class PesquisaBinaria {\n    public static int buscar(int[] lista, int alvo) {\n        // Implemente a pesquisa binária aqui\n        // Mantenha dois ponteiros: baixo e alto\n        // Calcule o meio: (baixo + alto) / 2\n        return -1;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class PesquisaBinariaTest {\n    @Test\n    public void testEncontrarElemento() {\n        int[] lista = {1, 3, 5, 7, 9, 11, 13, 15};\n        assertEquals(3, PesquisaBinaria.buscar(lista, 7));\n    }\n\n    @Test\n    public void testPrimeiroElemento() {\n        int[] lista = {2, 4, 6, 8, 10};\n        assertEquals(0, PesquisaBinaria.buscar(lista, 2));\n    }\n\n    @Test\n    public void testUltimoElemento() {\n        int[] lista = {2, 4, 6, 8, 10};\n        assertEquals(4, PesquisaBinaria.buscar(lista, 10));\n    }\n\n    @Test\n    public void testNaoEncontrado() {\n        int[] lista = {1, 3, 5, 7, 9};\n        assertEquals(-1, PesquisaBinaria.buscar(lista, 4));\n    }\n\n    @Test\n    public void testListaUmElemento() {\n        assertEquals(0, PesquisaBinaria.buscar(new int[]{42}, 42));\n        assertEquals(-1, PesquisaBinaria.buscar(new int[]{42}, 7));\n    }\n}',
 1, 'EASY', 100,
 'Use dois ponteiros: baixo=0, alto=lista.length-1. A cada iteração: meio=(baixo+alto)/2. Se lista[meio]==alvo, retorne meio. Se lista[meio]<alvo, suba baixo=meio+1. Senão alto=meio-1.');

-- ── Módulo 6.2: Ordenação por Seleção ───────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(36, 6, 'Arrays, Listas Ligadas e Selection Sort',
 'Como memória funciona e o primeiro algoritmo de ordenação.',
'# Arrays, Listas Ligadas e Selection Sort\n\n**Livro:** Entendendo Algoritmos — Cap. 2\n\n## Arrays vs Listas Ligadas\n\n| Operação | Array | Lista Ligada |\n|---|---|---|\n| Leitura (índice) | O(1) | O(n) |\n| Inserção no início | O(n) | O(1) |\n| Inserção no fim | O(1)* | O(1)* |\n| Deleção | O(n) | O(1)** |\n\n*Amortizado | **Com ponteiro para o nó\n\n## Selection Sort — O(n²)\n\nIdeia: encontrar o menor elemento, colocá-lo na posição correta. Repetir para o resto.\n\n```java\npublic static int[] selectionSort(int[] arr) {\n    int n = arr.length;\n    for (int i = 0; i < n - 1; i++) {\n        int indiceMinimo = i;\n        for (int j = i + 1; j < n; j++) {\n            if (arr[j] < arr[indiceMinimo]) {\n                indiceMinimo = j;\n            }\n        }\n        // Trocar arr[i] com arr[indiceMinimo]\n        int temp = arr[i];\n        arr[i] = arr[indiceMinimo];\n        arr[indiceMinimo] = temp;\n    }\n    return arr;\n}\n```\n\n## Por que O(n²)?\n\nPara N=5: 5 + 4 + 3 + 2 + 1 = 15 operações ≈ n²/2 → **O(n²)**\n\n> **Analogia do livro:** É como organizar baralhos — você sempre procura o menor de todos os restantes.',
 2);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(51, 36,
 'Selection Sort',
 'Implemente o algoritmo Selection Sort para ordenar um array de inteiros em ordem crescente. A cada iteração, encontre o MENOR elemento do restante e coloque-o na posição correta.',
'public class SelectionSort {\n    public static int[] ordenar(int[] arr) {\n        // Para cada posição i, encontre o menor elemento em arr[i..n-1]\n        // e troque com arr[i]\n        return arr;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class SelectionSortTest {\n    @Test\n    public void testOrdenacaoBasica() {\n        int[] resultado = SelectionSort.ordenar(new int[]{5, 3, 1, 4, 2});\n        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, resultado);\n    }\n\n    @Test\n    public void testJaOrdenado() {\n        int[] resultado = SelectionSort.ordenar(new int[]{1, 2, 3, 4, 5});\n        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, resultado);\n    }\n\n    @Test\n    public void testInvertido() {\n        int[] resultado = SelectionSort.ordenar(new int[]{5, 4, 3, 2, 1});\n        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, resultado);\n    }\n\n    @Test\n    public void testComRepetidos() {\n        int[] resultado = SelectionSort.ordenar(new int[]{3, 1, 3, 2, 1});\n        assertArrayEquals(new int[]{1, 1, 2, 3, 3}, resultado);\n    }\n}',
 1, 'EASY', 100,
 'Loop externo: i de 0 a n-2. Dentro: encontre indiceMinimo=i, varra j de i+1 até n-1 atualizando indiceMinimo se arr[j]<arr[indiceMinimo]. Ao final do loop interno, troque arr[i] com arr[indiceMinimo].');

-- ── Módulo 6.3: Recursão ─────────────────────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(37, 6, 'Recursão e Casos Base',
 'Como dividir problemas em subproblemas menores. A base da programação funcional.',
'# Recursão\n\n**Livro:** Entendendo Algoritmos — Cap. 3\n\n## O que é Recursão?\n\nUma função que **chama a si mesma** até atingir um **caso base**.\n\n```java\npublic static int fatorial(int n) {\n    if (n <= 1) return 1;        // CASO BASE\n    return n * fatorial(n - 1);  // CASO RECURSIVO\n}\n```\n\n## As Duas Partes de Qualquer Função Recursiva\n\n1. **Caso Base** — quando parar (sem chamada recursiva)\n2. **Caso Recursivo** — chama a si mesmo com uma entrada menor\n\n> **Sem caso base = StackOverflowError!**\n\n## A Pilha de Chamadas (Call Stack)\n\n```\nfatorial(3)\n  └── 3 * fatorial(2)\n           └── 2 * fatorial(1)\n                    └── retorna 1   ← CASO BASE\n                retorna 2 * 1 = 2\n       retorna 3 * 2 = 6\n```\n\nCada chamada ocupa espaço na **stack**. Por isso recursão muito profunda causa `StackOverflowError`.\n\n## Soma de Array com Recursão\n\n```java\npublic static int soma(int[] arr, int i) {\n    if (i == arr.length) return 0;           // caso base\n    return arr[i] + soma(arr, i + 1);        // recursivo\n}\n```\n\n**Dica do livro:** Todo loop pode ser escrito como recursão. Mas nem sempre vale a pena — use recursão quando ela torna o código mais legível.',
 3);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(52, 37,
 'Contagem Recursiva',
 'Implemente RECURSIVAMENTE as funções: (1) soma(int[] arr) — soma todos os elementos de um array; (2) contar(int[] arr) — conta o número de elementos; (3) maximo(int[] arr) — retorna o maior elemento. Proibido usar loops (for/while)!',
'public class Recursao {\n    // Soma todos os elementos do array recursivamente\n    public static int soma(int[] arr) {\n        return somaHelper(arr, 0);\n    }\n    private static int somaHelper(int[] arr, int i) {\n        // Caso base: se i == arr.length, retorne 0\n        // Caso recursivo: arr[i] + somaHelper(arr, i+1)\n        return 0;\n    }\n\n    // Conta os elementos do array recursivamente\n    public static int contar(int[] arr) {\n        return contarHelper(arr, 0);\n    }\n    private static int contarHelper(int[] arr, int i) {\n        return 0;\n    }\n\n    // Retorna o maior elemento recursivamente\n    public static int maximo(int[] arr) {\n        return maximoHelper(arr, 0, arr[0]);\n    }\n    private static int maximoHelper(int[] arr, int i, int max) {\n        return max;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class RecursaoTest {\n    @Test\n    public void testSoma() {\n        assertEquals(15, Recursao.soma(new int[]{1, 2, 3, 4, 5}));\n        assertEquals(0,  Recursao.soma(new int[]{}));\n        assertEquals(10, Recursao.soma(new int[]{10}));\n    }\n\n    @Test\n    public void testContar() {\n        assertEquals(5, Recursao.contar(new int[]{1, 2, 3, 4, 5}));\n        assertEquals(0, Recursao.contar(new int[]{}));\n        assertEquals(1, Recursao.contar(new int[]{42}));\n    }\n\n    @Test\n    public void testMaximo() {\n        assertEquals(9, Recursao.maximo(new int[]{3, 1, 9, 2, 7}));\n        assertEquals(5, Recursao.maximo(new int[]{5}));\n        assertEquals(8, Recursao.maximo(new int[]{1, 8, 3}));\n    }\n}',
 1, 'MEDIUM', 120,
 'Para soma: caso base i==arr.length retorna 0, recursivo: arr[i]+somaHelper(arr, i+1). Para contar: caso base i==arr.length retorna 0, recursivo: 1+contarHelper(arr, i+1). Para maximo: compare arr[i] com max a cada passo.');

-- ── Módulo 6.4: QuickSort ────────────────────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(38, 6, 'QuickSort e Dividir para Conquistar',
 'O algoritmo de ordenação mais usado na prática. Aprenda a estratégia D&C.',
'# QuickSort — Dividir para Conquistar\n\n**Livro:** Entendendo Algoritmos — Cap. 4\n\n## A Estratégia D&C (Divide and Conquer)\n\n1. Escolha um **pivô**\n2. **Partição:** separe em "menores que pivô" e "maiores que pivô"\n3. **Recursão:** ordene cada parte\n4. **Combine:** [menores] + [pivô] + [maiores]\n\n## Implementação em Java\n\n```java\npublic static int[] quicksort(int[] arr) {\n    if (arr.length <= 1) return arr;  // CASO BASE\n\n    int pivo = arr[arr.length / 2];\n\n    // Partição\n    int[] menores = Arrays.stream(arr).filter(x -> x < pivo).toArray();\n    int[] iguais  = Arrays.stream(arr).filter(x -> x == pivo).toArray();\n    int[] maiores = Arrays.stream(arr).filter(x -> x > pivo).toArray();\n\n    // Combinar\n    return concat(quicksort(menores), iguais, quicksort(maiores));\n}\n```\n\n## Complexidade\n\n| Caso | Complexidade |\n|---|---|\n| Melhor caso | O(n log n) |\n| Caso médio | O(n log n) |\n| Pior caso | O(n²) — pivô sempre o menor/maior |\n\n**Por que é mais rápido na prática que o MergeSort?**\nA constante oculta do QuickSort é menor. Com pivô aleatório, o pior caso é extremamente improvável.\n\n## D&C: Receita Geral\n\n1. Identifique o **caso base** mais simples\n2. Reduza o problema até atingi-lo\n3. **Confie na recursão** — assuma que funciona para n-1',
 4);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(53, 38,
 'QuickSort com D&C',
 'Implemente o QuickSort usando a estratégia Dividir para Conquistar. Use o elemento do MEIO como pivô. Separe em três listas: menores, iguais, maiores. Ordene recursivamente e combine.',
'import java.util.*;\nimport java.util.stream.*;\n\npublic class QuickSort {\n    public static int[] ordenar(int[] arr) {\n        if (arr.length <= 1) return arr; // caso base\n\n        int pivo = arr[arr.length / 2];\n\n        // Crie as tres particoes usando streams ou loops\n        int[] menores = null; // < pivo\n        int[] iguais  = null; // == pivo\n        int[] maiores = null; // > pivo\n\n        // Combine: ordenar(menores) + iguais + ordenar(maiores)\n        return arr;\n    }\n\n    private static int[] concat(int[] a, int[] b, int[] c) {\n        int[] result = new int[a.length + b.length + c.length];\n        System.arraycopy(a, 0, result, 0, a.length);\n        System.arraycopy(b, 0, result, a.length, b.length);\n        System.arraycopy(c, 0, result, a.length + b.length, c.length);\n        return result;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class QuickSortTest {\n    @Test\n    public void testBasico() {\n        assertArrayEquals(new int[]{1,2,3,4,5}, QuickSort.ordenar(new int[]{3,1,5,2,4}));\n    }\n\n    @Test\n    public void testJaOrdenado() {\n        assertArrayEquals(new int[]{1,2,3}, QuickSort.ordenar(new int[]{1,2,3}));\n    }\n\n    @Test\n    public void testInvertido() {\n        assertArrayEquals(new int[]{1,2,3,4,5}, QuickSort.ordenar(new int[]{5,4,3,2,1}));\n    }\n\n    @Test\n    public void testUmElemento() {\n        assertArrayEquals(new int[]{7}, QuickSort.ordenar(new int[]{7}));\n    }\n\n    @Test\n    public void testComRepetidos() {\n        assertArrayEquals(new int[]{1,1,2,3,3}, QuickSort.ordenar(new int[]{3,1,3,2,1}));\n    }\n}',
 1, 'MEDIUM', 130,
 'Caso base: arr.length<=1 retorna arr. Pivô: arr[arr.length/2]. Particione com IntStream.of(arr).filter(x->x<pivo).toArray(). Combine com concat(ordenar(menores), iguais, ordenar(maiores)).');

-- ── Módulo 6.5: Tabelas Hash ─────────────────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(39, 6, 'Tabelas Hash (HashMap)',
 'A estrutura de dados mais versátil. O(1) para busca, inserção e remoção.',
'# Tabelas Hash\n\n**Livro:** Entendendo Algoritmos — Cap. 5\n\n## O que é uma Tabela Hash?\n\nUm array de pares **chave → valor** onde a posição é calculada por uma **função hash**.\n\n```java\nMap<String, Integer> preco = new HashMap<>();\npreco.put("maca",   150);\npreco.put("banana", 60);\npreco.put("uva",    300);\n\nSystem.out.println(preco.get("maca")); // 150 — O(1)!\n```\n\n## Como Funciona\n\n```\n"maca" → hash("maca") → 3 → arr[3] = 150\n```\n\nA função hash converte a chave em um índice do array.\n\n## Colisões\n\nQuando duas chaves mapeiam para o mesmo índice. Resolvidas por **encadeamento** (linked list no slot).\n\nCom fator de carga < 0.7, as colisões são raras e o desempenho permanece O(1).\n\n## Casos de Uso Clássicos (do livro)\n\n1. **Cache/Memoização** — armazenar resultados já calculados\n2. **Verificar duplicatas** — já vi este item?\n3. **Grafos** — representar adjacências\n\n```java\n// Cache DNS simplificado\nMap<String, String> cache = new HashMap<>();\n\npublic String resolverDNS(String site) {\n    if (cache.containsKey(site)) {\n        return cache.get(site); // cache hit!\n    }\n    String ip = buscarNoDNS(site);\n    cache.put(site, ip);\n    return ip;\n}\n```\n\n## Complexidade\n\n| Operação | Caso Médio | Pior Caso |\n|---|---|---|\n| Busca | O(1) | O(n) |\n| Inserção | O(1) | O(n) |\n| Remoção | O(1) | O(n) |',
 5);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(54, 39,
 'Frequência de Palavras com HashMap',
 'Use um HashMap para contar a frequência de cada palavra em uma lista. Retorne um Map onde a chave é a palavra e o valor é o número de ocorrências. Complexidade: O(n).',
'import java.util.*;\n\npublic class FrequenciaPalavras {\n    public static Map<String, Integer> contar(List<String> palavras) {\n        // Use HashMap para contar ocorrencias\n        // Para cada palavra: map.put(palavra, map.getOrDefault(palavra, 0) + 1)\n        return new HashMap<>();\n    }\n\n    // Retorne a palavra mais frequente\n    public static String maisFrecuente(List<String> palavras) {\n        // Use contar() e encontre o max por valor\n        return "";\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.*;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class FrequenciaPalavrasTest {\n    @Test\n    public void testContagem() {\n        List<String> lista = List.of("java", "python", "java", "java", "python");\n        Map<String, Integer> freq = FrequenciaPalavras.contar(lista);\n        assertEquals(3, freq.get("java"));\n        assertEquals(2, freq.get("python"));\n    }\n\n    @Test\n    public void testPalavraUnica() {\n        Map<String, Integer> freq = FrequenciaPalavras.contar(List.of("spring"));\n        assertEquals(1, freq.get("spring"));\n    }\n\n    @Test\n    public void testMaisFrequente() {\n        List<String> lista = List.of("a", "b", "a", "c", "a", "b");\n        assertEquals("a", FrequenciaPalavras.maisFrecuente(lista));\n    }\n\n    @Test\n    public void testListaVazia() {\n        assertEquals(0, FrequenciaPalavras.contar(new ArrayList<>()).size());\n    }\n}',
 1, 'EASY', 100,
 'Use map.getOrDefault(palavra, 0)+1 para contar. Para maisFrecuente: contar(palavras).entrySet().stream().max(Map.Entry.comparingByValue()).get().getKey()');

-- ── Módulo 6.6: Grafos e BFS ─────────────────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(40, 6, 'Grafos e Busca em Largura (BFS)',
 'Modelando relacionamentos. Como encontrar o caminho mais curto.',
'# Grafos e Busca em Largura (BFS)\n\n**Livro:** Entendendo Algoritmos — Cap. 6\n\n## O que é um Grafo?\n\nUm grafo é um conjunto de **nós (vértices)** conectados por **arestas**.\n\n```\nVocê ──── Alice\n │          │\nBob ──── Charlie\n```\n\n## Representação em Java\n\n```java\nMap<String, List<String>> grafo = new HashMap<>();\ngrafo.put("voce",    List.of("alice", "bob"));\ngrafo.put("alice",   List.of("charlie"));\ngrafo.put("bob",     List.of("charlie"));\ngrafo.put("charlie", List.of());\n```\n\n## BFS — Busca em Largura\n\nEncontra o **caminho mais curto** (menor número de arestas) entre dois nós.\n\n**Algoritmo:**\n1. Adicione o nó inicial à **fila** (Queue)\n2. Enquanto a fila não estiver vazia:\n   - Retire o primeiro nó\n   - Se é o alvo, ACHOU!\n   - Senão, adicione seus vizinhos à fila (se não visitados)\n\n```java\npublic static boolean bfs(Map<String, List<String>> grafo,\n                           String inicio, String alvo) {\n    Queue<String> fila = new LinkedList<>();\n    Set<String>   visitados = new HashSet<>();\n\n    fila.add(inicio);\n    while (!fila.isEmpty()) {\n        String no = fila.poll();\n        if (no.equals(alvo)) return true;\n        if (!visitados.contains(no)) {\n            visitados.add(no);\n            fila.addAll(grafo.getOrDefault(no, List.of()));\n        }\n    }\n    return false;\n}\n```\n\n## Complexidade\n\n**O(V + E)** — V = vértices, E = arestas\n\n> **Por que Queue e não Stack?** Queue garante que visitamos os nós em ordem de distância (1 aresta, depois 2, etc). Stack daria DFS.',
 6);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(55, 40,
 'BFS — Menor Número de Saltos',
 'Implemente BFS para encontrar o MENOR número de nós intermediários entre dois nós em um grafo. Retorne a distância (número de arestas) ou -1 se não existir caminho.',
'import java.util.*;\n\npublic class BFS {\n    // Retorna o numero de arestas no caminho mais curto\n    // entre inicio e alvo, ou -1 se nao houver caminho\n    public static int distancia(Map<String, List<String>> grafo,\n                                String inicio, String alvo) {\n        if (inicio.equals(alvo)) return 0;\n\n        // Use Queue<String> para BFS\n        // Use Map<String, Integer> para guardar a distancia de cada no\n        return -1;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.*;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class BFSTest {\n    private Map<String, List<String>> grafo() {\n        Map<String, List<String>> g = new HashMap<>();\n        g.put("A", List.of("B", "C"));\n        g.put("B", List.of("D"));\n        g.put("C", List.of("D", "E"));\n        g.put("D", List.of("F"));\n        g.put("E", List.of("F"));\n        g.put("F", List.of());\n        return g;\n    }\n\n    @Test\n    public void testMesmoNo() {\n        assertEquals(0, BFS.distancia(grafo(), "A", "A"));\n    }\n\n    @Test\n    public void testVizinhoImediato() {\n        assertEquals(1, BFS.distancia(grafo(), "A", "B"));\n    }\n\n    @Test\n    public void testDoisSaltos() {\n        assertEquals(2, BFS.distancia(grafo(), "A", "D"));\n    }\n\n    @Test\n    public void testSemCaminho() {\n        Map<String, List<String>> g = new HashMap<>();\n        g.put("X", List.of()); g.put("Y", List.of());\n        assertEquals(-1, BFS.distancia(g, "X", "Y"));\n    }\n}',
 1, 'HARD', 150,
 'Use Queue<String> fila e Map<String,Integer> distancias. Inicie fila com inicio, distancias.put(inicio,0). A cada nó retirado, para cada vizinho nao visitado: distancias.put(vizinho, dist+1), adicione na fila.');

-- ── Módulo 6.7: Programação Dinâmica ────────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(41, 6, 'Algoritmos Gulosos e Programação Dinâmica',
 'As duas estratégias mais poderosas para resolver problemas de otimização.',
'# Algoritmos Gulosos e Programação Dinâmica\n\n**Livro:** Entendendo Algoritmos — Cap. 8 e 9\n\n## Algoritmo Guloso (Greedy)\n\nEm cada etapa, faz a **escolha localmente ótima** esperando chegar ao ótimo global.\n\n### Exemplo: Troco Mínimo\n```java\n// Dar troco com o menor numero de moedas\npublic static int[] troco(int valor, int[] moedas) {\n    // Ordenar moedas em ordem decrescente\n    // A cada passo, pegar a maior moeda possivel\n}\n```\n\n**Nem sempre funciona!** Com moedas {1, 3, 4} e valor 6:\n- Guloso: 4+1+1 = 3 moedas\n- Ótimo: 3+3 = **2 moedas**\n\n## Programação Dinâmica (DP)\n\nResolve o problema quebrando em **subproblemas sobrepostos** e **memorizando** os resultados.\n\n### O Problema da Mochila (Knapsack)\n\nDados itens com peso e valor, e uma mochila com capacidade W, maximize o valor total.\n\n```java\n// dp[i][w] = maximo valor com i itens e capacidade w\nint[][] dp = new int[n+1][W+1];\nfor (int i = 1; i <= n; i++) {\n    for (int w = 0; w <= W; w++) {\n        // Nao pegar item i\n        dp[i][w] = dp[i-1][w];\n        // Pegar item i (se couber)\n        if (peso[i] <= w) {\n            dp[i][w] = Math.max(dp[i][w],\n                                dp[i-1][w-peso[i]] + valor[i]);\n        }\n    }\n}\n```\n\n## Fibonacci com Memoização\n\n```java\nMap<Integer, Long> memo = new HashMap<>();\n\npublic static long fib(int n) {\n    if (n <= 1) return n;\n    if (memo.containsKey(n)) return memo.get(n);\n    long resultado = fib(n-1) + fib(n-2);\n    memo.put(n, resultado);\n    return resultado;\n}\n```\n\nSem memoização: **O(2ⁿ)** | Com memoização: **O(n)**',
 7);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(56, 41,
 'Fibonacci com Memoização (DP Top-Down)',
 'Implemente Fibonacci com MEMOIZAÇÃO para evitar recálculos. A versão ingênua é O(2ⁿ) — a sua deve ser O(n). fib(0)=0, fib(1)=1, fib(n)=fib(n-1)+fib(n-2).',
'import java.util.HashMap;\nimport java.util.Map;\n\npublic class Fibonacci {\n    private static Map<Integer, Long> memo = new HashMap<>();\n\n    public static long fib(int n) {\n        // Casos base: n=0 retorna 0, n=1 retorna 1\n        // Verifica memo antes de calcular\n        // Armazena em memo antes de retornar\n        return 0;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class FibonacciTest {\n    @Test\n    public void testCasosBase() {\n        assertEquals(0L, Fibonacci.fib(0));\n        assertEquals(1L, Fibonacci.fib(1));\n    }\n\n    @Test\n    public void testPequenos() {\n        assertEquals(1L,  Fibonacci.fib(2));\n        assertEquals(2L,  Fibonacci.fib(3));\n        assertEquals(3L,  Fibonacci.fib(4));\n        assertEquals(5L,  Fibonacci.fib(5));\n        assertEquals(8L,  Fibonacci.fib(6));\n    }\n\n    @Test\n    public void testGrande() {\n        assertEquals(55L,  Fibonacci.fib(10));\n        assertEquals(6765L, Fibonacci.fib(20));\n    }\n\n    @Test\n    public void testMuitoGrande() {\n        // Sem memoizacao isso levaria anos\n        assertTrue(Fibonacci.fib(50) > 0);\n    }\n}',
 1, 'MEDIUM', 120,
 'if(n<=0) return 0; if(n==1) return 1; if(memo.containsKey(n)) return memo.get(n); long r = fib(n-1)+fib(n-2); memo.put(n,r); return r;');

-- Quizzes Trilha 6
INSERT INTO quizzes (id, modulo_id, pergunta, ordem) VALUES
(51, 35, 'Qual a complexidade da Pesquisa Binária no pior caso?', 1),
(52, 36, 'Qual a complexidade do Selection Sort?', 1),
(53, 37, 'O que acontece se uma função recursiva não tiver caso base?', 1),
(54, 38, 'Qual é a complexidade média do QuickSort?', 1),
(55, 39, 'Qual estrutura de dados o Java usa internamente em um HashMap para resolver colisões?', 1),
(56, 40, 'Por que BFS usa Queue e não Stack?', 1),
(57, 41, 'Qual a vantagem da Programação Dinâmica sobre a recursão simples?', 1);

INSERT INTO quiz_opcoes (id, quiz_id, texto_opcao, is_correta) VALUES
-- Q51: Complexidade Pesquisa Binária
(201, 51, 'O(n)', false),
(202, 51, 'O(log n)', true),
(203, 51, 'O(n²)', false),
(204, 51, 'O(1)', false),
-- Q52: Selection Sort
(205, 52, 'O(n)', false),
(206, 52, 'O(n log n)', false),
(207, 52, 'O(n²)', true),
(208, 52, 'O(log n)', false),
-- Q53: Sem caso base
(209, 53, 'A função retorna null', false),
(210, 53, 'O compilador dá erro', false),
(211, 53, 'Ocorre StackOverflowError em tempo de execução', true),
(212, 53, 'A função retorna 0', false),
-- Q54: QuickSort médio
(213, 54, 'O(n²)', false),
(214, 54, 'O(n log n)', true),
(215, 54, 'O(n)', false),
(216, 54, 'O(log n)', false),
-- Q55: HashMap colisões
(217, 55, 'Árvore AVL', false),
(218, 55, 'Lista encadeada (ou Red-Black Tree a partir do Java 8)', true),
(219, 55, 'Stack', false),
(220, 55, 'Array de arrays', false),
-- Q56: BFS Queue vs Stack
(221, 56, 'Queue é mais rápida que Stack', false),
(222, 56, 'Stack não existe em Java', false),
(223, 56, 'Queue (FIFO) garante visitar nós por ordem de distância, encontrando o caminho mais curto', true),
(224, 56, 'Apenas por convenção', false),
-- Q57: DP vantagem
(225, 57, 'Usa menos memória que a recursão', false),
(226, 57, 'Elimina recálculos de subproblemas sobrepostos, reduzindo de O(2ⁿ) para O(n)', true),
(227, 57, 'É sempre mais simples de implementar', false),
(228, 57, 'Funciona apenas para problemas de grafos', false);

-- ============================================================
-- TRILHA 7: JAVA COMO PROGRAMAR — Deitel 10ª Edição
-- ============================================================
INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES
(7, 'Java Como Programar — Deitel 10ª Ed.',
 'Baseado no livro "Java: Como Programar" de Paul e Harvey Deitel. De OOP profunda a Generics, Streams, Lambdas, Threads e JDBC. O guia completo do desenvolvedor Java profissional.',
 'PLENO', 7);

-- ── Módulo 7.1: OOP Avançada — Herança e Polimorfismo ────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(42, 7, 'Herança, Polimorfismo e @Override',
 'O coração da OOP Java. Como reutilizar e especializar comportamento.',
'# Herança e Polimorfismo\n\n**Livro:** Java: Como Programar — Cap. 9 e 10\n\n## Hierarquia de Classes\n\n```java\npublic class Animal {\n    private String nome;\n\n    public Animal(String nome) { this.nome = nome; }\n\n    public String getNome() { return nome; }\n\n    // Método polimórfico\n    public String emitirSom() {\n        return "...";\n    }\n}\n\npublic class Cachorro extends Animal {\n    public Cachorro(String nome) { super(nome); }\n\n    @Override\n    public String emitirSom() {\n        return "Au Au!";\n    }\n}\n\npublic class Gato extends Animal {\n    public Gato(String nome) { super(nome); }\n\n    @Override\n    public String emitirSom() {\n        return "Miau!";\n    }\n}\n```\n\n## Polimorfismo em Ação\n\n```java\nList<Animal> animais = List.of(\n    new Cachorro("Rex"),\n    new Gato("Whiskers"),\n    new Cachorro("Buddy")\n);\n\n// Binding dinâmico — decide em RUNTIME qual método chamar\nfor (Animal a : animais) {\n    System.out.println(a.getNome() + ": " + a.emitirSom());\n}\n// Rex: Au Au!\n// Whiskers: Miau!\n// Buddy: Au Au!\n```\n\n## super — Acessando a Superclasse\n\n```java\npublic class Funcionario {\n    public double calcularSalario() { return 3000.0; }\n}\n\npublic class Gerente extends Funcionario {\n    private double bonus;\n\n    public Gerente(double bonus) { this.bonus = bonus; }\n\n    @Override\n    public double calcularSalario() {\n        return super.calcularSalario() + bonus; // reusa o pai!\n    }\n}\n```\n\n## instanceof\n\n```java\nAnimal a = new Cachorro("Rex");\nif (a instanceof Cachorro c) {  // Java 16+: pattern matching\n    c.buscarBola();\n}\n```',
 1);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(57, 42,
 'Hierarquia de Formas Geométricas',
 'Crie uma hierarquia OOP: Forma (abstract) com método area(). Circulo extends Forma (usa Math.PI * r²). Retangulo extends Forma (usa largura * altura). Triangulo extends Forma (usa base * altura / 2). Todas retornam area() com 2 casas decimais (arredondado).',
'public abstract class Forma {\n    public abstract double area();\n\n    // Retorna a area formatada com 2 casas decimais\n    public String areaFormatada() {\n        return String.format("%.2f", area());\n    }\n}\n\npublic class Circulo extends Forma {\n    private double raio;\n    public Circulo(double raio) { this.raio = raio; }\n\n    @Override\n    public double area() {\n        // Math.PI * raio * raio\n        return 0;\n    }\n}\n\npublic class Retangulo extends Forma {\n    private double largura, altura;\n    public Retangulo(double largura, double altura) {\n        this.largura = largura;\n        this.altura = altura;\n    }\n\n    @Override\n    public double area() { return 0; }\n}\n\npublic class Triangulo extends Forma {\n    private double base, altura;\n    public Triangulo(double base, double altura) {\n        this.base = base;\n        this.altura = altura;\n    }\n\n    @Override\n    public double area() { return 0; }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class HierarquiaFormasTest {\n    @Test\n    public void testCirculo() {\n        Circulo c = new Circulo(5);\n        assertEquals(Math.PI * 25, c.area(), 0.001);\n    }\n\n    @Test\n    public void testRetangulo() {\n        Retangulo r = new Retangulo(4, 6);\n        assertEquals(24.0, r.area(), 0.001);\n    }\n\n    @Test\n    public void testTriangulo() {\n        Triangulo t = new Triangulo(3, 8);\n        assertEquals(12.0, t.area(), 0.001);\n    }\n\n    @Test\n    public void testPolimorfismo() {\n        Forma[] formas = {new Circulo(1), new Retangulo(2,3), new Triangulo(4,5)};\n        assertEquals(Math.PI, formas[0].area(), 0.001);\n        assertEquals(6.0, formas[1].area(), 0.001);\n        assertEquals(10.0, formas[2].area(), 0.001);\n    }\n}',
 1, 'EASY', 100,
 'Circulo: return Math.PI * raio * raio; Retangulo: return largura * altura; Triangulo: return base * altura / 2.0; As classes precisam ser public e no mesmo arquivo, ou declara as subclasses como non-public.');

-- ── Módulo 7.2: Interfaces e Classes Abstratas ───────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(43, 7, 'Interfaces, Classes Abstratas e Contratos',
 'O princípio de programar para a interface, não para a implementação.',
'# Interfaces e Classes Abstratas\n\n**Livro:** Java: Como Programar — Cap. 10\n\n## Classe Abstrata vs Interface\n\n| Aspecto | Classe Abstrata | Interface |\n|---|---|---|\n| Instanciável | Não | Não |\n| Herança | extends (1 só) | implements (múltiplas) |\n| Campos | Pode ter estado | Apenas static final |\n| Métodos | Concretos + abstratos | Default, static, abstratos |\n| Usar quando | "É um" com estado | "Pode fazer" (comportamento) |\n\n## Interface — Contrato\n\n```java\npublic interface Pagavel {\n    double calcularPagamento();\n\n    // Método default (Java 8+)\n    default String descricaoPagamento() {\n        return String.format("Pagamento: R$ %.2f", calcularPagamento());\n    }\n}\n\npublic class Funcionario implements Pagavel {\n    private double salario;\n    public Funcionario(double salario) { this.salario = salario; }\n\n    @Override\n    public double calcularPagamento() { return salario; }\n}\n\npublic class PecaTrabalho implements Pagavel {\n    private int pecas;\n    private double precoPorPeca;\n    public PecaTrabalho(int pecas, double preco) {\n        this.pecas = pecas;\n        this.precoPorPeca = preco;\n    }\n\n    @Override\n    public double calcularPagamento() { return pecas * precoPorPeca; }\n}\n```\n\n## Comparable — A Interface Mais Importante\n\n```java\npublic class Produto implements Comparable<Produto> {\n    private String nome;\n    private double preco;\n\n    @Override\n    public int compareTo(Produto outro) {\n        return Double.compare(this.preco, outro.preco);\n    }\n}\n\nList<Produto> lista = ...\nCollections.sort(lista); // funciona porque implementa Comparable!\n```',
 2);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(58, 43,
 'Interface Comparable — Ordenação de Alunos',
 'Crie a classe Aluno implementando Comparable<Aluno>. Aluno tem nome (String) e nota (double). O método compareTo deve ordenar por NOTA decrescente (maior nota primeiro). Se notas iguais, ordene por nome alfabético.',
'import java.util.*;\n\npublic class Aluno implements Comparable<Aluno> {\n    private String nome;\n    private double nota;\n\n    public Aluno(String nome, double nota) {\n        this.nome = nome;\n        this.nota = nota;\n    }\n\n    public String getNome() { return nome; }\n    public double getNota() { return nota; }\n\n    @Override\n    public int compareTo(Aluno outro) {\n        // Ordem decrescente de nota\n        // Se notas iguais, ordem crescente de nome\n        return 0;\n    }\n\n    @Override\n    public String toString() {\n        return nome + "(" + nota + ")";\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.*;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class AlunoTest {\n    @Test\n    public void testOrdemDecrescente() {\n        List<Aluno> alunos = new ArrayList<>(List.of(\n            new Aluno("Carlos", 7.5),\n            new Aluno("Ana",    9.0),\n            new Aluno("Bruno",  8.0)\n        ));\n        Collections.sort(alunos);\n        assertEquals("Ana",    alunos.get(0).getNome());\n        assertEquals("Bruno",  alunos.get(1).getNome());\n        assertEquals("Carlos", alunos.get(2).getNome());\n    }\n\n    @Test\n    public void testNotasIguaisAlfabetico() {\n        List<Aluno> alunos = new ArrayList<>(List.of(\n            new Aluno("Zara",  8.0),\n            new Aluno("Ana",   8.0),\n            new Aluno("Maria", 8.0)\n        ));\n        Collections.sort(alunos);\n        assertEquals("Ana",   alunos.get(0).getNome());\n        assertEquals("Maria", alunos.get(1).getNome());\n        assertEquals("Zara",  alunos.get(2).getNome());\n    }\n\n    @Test\n    public void testCompareToBasico() {\n        Aluno a = new Aluno("A", 9.0);\n        Aluno b = new Aluno("B", 7.0);\n        assertTrue(a.compareTo(b) < 0); // a vem antes (nota maior)\n    }\n}',
 1, 'MEDIUM', 120,
 'int cmp = Double.compare(outro.nota, this.nota); // invertido para decrescente. if(cmp != 0) return cmp; return this.nome.compareTo(outro.nome);');

-- ── Módulo 7.3: Tratamento de Exceções ──────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(44, 7, 'Tratamento Robusto de Exceções',
 'Como criar código que não quebra. Exceções checked, unchecked e customizadas.',
'# Tratamento de Exceções em Java\n\n**Livro:** Java: Como Programar — Cap. 11\n\n## Hierarquia de Exceções\n\n```\nThrowable\n├── Error (não capturar — problemas da JVM)\n└── Exception\n    ├── IOException (CHECKED — deve declarar/capturar)\n    ├── SQLException (CHECKED)\n    └── RuntimeException (UNCHECKED — opcional capturar)\n        ├── NullPointerException\n        ├── IllegalArgumentException\n        ├── IndexOutOfBoundsException\n        └── ArithmeticException\n```\n\n## try-catch-finally\n\n```java\npublic static double dividir(double a, double b) {\n    try {\n        if (b == 0) throw new ArithmeticException("Divisão por zero!");\n        return a / b;\n    } catch (ArithmeticException e) {\n        System.err.println("Erro: " + e.getMessage());\n        return 0;\n    } finally {\n        System.out.println("Operação concluída"); // SEMPRE executa\n    }\n}\n```\n\n## Exceção Customizada\n\n```java\n// Checked exception\npublic class SaldoInsuficienteException extends Exception {\n    private double saldo;\n    private double valor;\n\n    public SaldoInsuficienteException(double saldo, double valor) {\n        super(String.format("Saldo %.2f insuficiente para saque de %.2f", saldo, valor));\n        this.saldo = saldo;\n        this.valor = valor;\n    }\n\n    public double getSaldo() { return saldo; }\n    public double getValor() { return valor; }\n}\n\n// Uso\npublic class ContaBancaria {\n    private double saldo;\n\n    public void sacar(double valor) throws SaldoInsuficienteException {\n        if (valor > saldo) {\n            throw new SaldoInsuficienteException(saldo, valor);\n        }\n        saldo -= valor;\n    }\n}\n```\n\n## try-with-resources (Java 7+)\n\n```java\ntry (BufferedReader br = new BufferedReader(new FileReader("arquivo.txt"))) {\n    String linha = br.readLine();\n    // br.close() é chamado AUTOMATICAMENTE\n}\n```',
 3);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(59, 44,
 'Conta Bancária com Exceções',
 'Implemente ContaBancaria com: saldo inicial via construtor, depositar(double) lança IllegalArgumentException se valor <= 0, sacar(double) lança SaldoInsuficienteException (sua exceção customizada) se saldo insuficiente, e getSaldo().',
'public class SaldoInsuficienteException extends RuntimeException {\n    private final double saldoAtual;\n    private final double valorSolicitado;\n\n    public SaldoInsuficienteException(double saldoAtual, double valorSolicitado) {\n        super("Saldo insuficiente: R$" + saldoAtual + " para saque de R$" + valorSolicitado);\n        this.saldoAtual = saldoAtual;\n        this.valorSolicitado = valorSolicitado;\n    }\n\n    public double getSaldoAtual() { return saldoAtual; }\n    public double getValorSolicitado() { return valorSolicitado; }\n}\n\npublic class ContaBancaria {\n    private double saldo;\n\n    public ContaBancaria(double saldoInicial) {\n        if (saldoInicial < 0) throw new IllegalArgumentException("Saldo inicial nao pode ser negativo");\n        this.saldo = saldoInicial;\n    }\n\n    public void depositar(double valor) {\n        // Lance IllegalArgumentException se valor <= 0\n    }\n\n    public void sacar(double valor) {\n        // Lance SaldoInsuficienteException se saldo < valor\n    }\n\n    public double getSaldo() { return saldo; }\n}',
'import org.junit.jupiter.api.Test;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class ContaBancariaTest {\n    @Test\n    public void testDeposito() {\n        ContaBancaria conta = new ContaBancaria(100);\n        conta.depositar(50);\n        assertEquals(150.0, conta.getSaldo(), 0.001);\n    }\n\n    @Test\n    public void testSaque() {\n        ContaBancaria conta = new ContaBancaria(200);\n        conta.sacar(80);\n        assertEquals(120.0, conta.getSaldo(), 0.001);\n    }\n\n    @Test\n    public void testDepositoInvalido() {\n        ContaBancaria conta = new ContaBancaria(100);\n        assertThrows(IllegalArgumentException.class, () -> conta.depositar(0));\n        assertThrows(IllegalArgumentException.class, () -> conta.depositar(-10));\n    }\n\n    @Test\n    public void testSaldoInsuficiente() {\n        ContaBancaria conta = new ContaBancaria(50);\n        SaldoInsuficienteException ex = assertThrows(\n            SaldoInsuficienteException.class, () -> conta.sacar(100));\n        assertEquals(50.0, ex.getSaldoAtual(), 0.001);\n        assertEquals(100.0, ex.getValorSolicitado(), 0.001);\n    }\n}',
 1, 'MEDIUM', 120,
 'depositar: if(valor<=0) throw new IllegalArgumentException("Valor deve ser positivo"); saldo+=valor; sacar: if(valor>saldo) throw new SaldoInsuficienteException(saldo, valor); saldo-=valor;');

-- ── Módulo 7.4: Generics e Collections Framework ────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(45, 7, 'Generics e Collections Framework',
 'O sistema de tipos genéricos e as coleções prontas para uso profissional.',
'# Generics e Collections Framework\n\n**Livro:** Java: Como Programar — Cap. 16 e 20\n\n## Por que Generics?\n\nSem generics (pré-Java 5):\n```java\nList lista = new ArrayList();\nlista.add("texto");\nString s = (String) lista.get(0); // cast manual — ClassCastException em runtime!\n```\n\nCom generics:\n```java\nList<String> lista = new ArrayList<>();\nlista.add("texto");\nString s = lista.get(0); // sem cast — erro em COMPILE TIME!\n```\n\n## Classe Genérica\n\n```java\npublic class Par<A, B> {\n    private final A primeiro;\n    private final B segundo;\n\n    public Par(A primeiro, B segundo) {\n        this.primeiro = primeiro;\n        this.segundo = segundo;\n    }\n\n    public A getPrimeiro() { return primeiro; }\n    public B getSegundo()  { return segundo; }\n}\n\n// Uso\nPar<String, Integer> par = new Par<>("Java", 21);\n```\n\n## Collections Framework\n\n| Interface | Implementação | Uso |\n|---|---|---|\n| List | ArrayList, LinkedList | Sequência ordenada |\n| Set | HashSet, TreeSet | Sem duplicatas |\n| Map | HashMap, TreeMap | Chave → valor |\n| Queue | LinkedList, PriorityQueue | FIFO |\n| Deque | ArrayDeque | FIFO e LIFO |\n\n## Wildcards\n\n```java\n// Aceita List<Integer>, List<Double>, List<Number>\npublic static double soma(List<? extends Number> lista) {\n    return lista.stream()\n                .mapToDouble(Number::doubleValue)\n                .sum();\n}\n```',
 4);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(60, 45,
 'Pilha Genérica (Stack<T>)',
 'Implemente uma Pilha genérica (Pilha<T>) usando ArrayList internamente. Métodos: push(T item), pop() retorna e remove o topo (lança EmptyStackException se vazia), peek() retorna sem remover, isEmpty(), tamanho().',
'import java.util.*;\n\npublic class Pilha<T> {\n    private List<T> dados = new ArrayList<>();\n\n    // Adiciona elemento ao topo\n    public void push(T item) {\n    }\n\n    // Remove e retorna o topo. Lance EmptyStackException se vazia.\n    public T pop() {\n        return null;\n    }\n\n    // Retorna o topo sem remover. Lance EmptyStackException se vazia.\n    public T peek() {\n        return null;\n    }\n\n    public boolean isEmpty() { return dados.isEmpty(); }\n\n    public int tamanho() { return dados.size(); }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.EmptyStackException;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class PilhaTest {\n    @Test\n    public void testPushPop() {\n        Pilha<Integer> p = new Pilha<>();\n        p.push(1); p.push(2); p.push(3);\n        assertEquals(3, p.pop());\n        assertEquals(2, p.pop());\n        assertEquals(1, p.pop());\n    }\n\n    @Test\n    public void testPeek() {\n        Pilha<String> p = new Pilha<>();\n        p.push("a"); p.push("b");\n        assertEquals("b", p.peek());\n        assertEquals(2, p.tamanho()); // peek nao remove\n    }\n\n    @Test\n    public void testIsEmpty() {\n        Pilha<Double> p = new Pilha<>();\n        assertTrue(p.isEmpty());\n        p.push(3.14);\n        assertFalse(p.isEmpty());\n    }\n\n    @Test\n    public void testPopVazia() {\n        assertThrows(EmptyStackException.class, () -> new Pilha<>().pop());\n    }\n\n    @Test\n    public void testGenerico() {\n        Pilha<String> ps = new Pilha<>();\n        ps.push("Java"); ps.push("Spring");\n        assertEquals("Spring", ps.pop());\n        Pilha<Integer> pi = new Pilha<>();\n        pi.push(42);\n        assertEquals(42, pi.pop());\n    }\n}',
 1, 'MEDIUM', 130,
 'push: dados.add(item). pop: if(isEmpty()) throw new EmptyStackException(); return dados.remove(dados.size()-1). peek: if(isEmpty()) throw new EmptyStackException(); return dados.get(dados.size()-1).');

-- ── Módulo 7.5: Streams e Lambdas ───────────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(46, 7, 'Lambdas, Streams e Programação Funcional',
 'Java 8+ transformado: processe coleções de forma declarativa e expressiva.',
'# Lambdas e Streams (Java 8+)\n\n**Livro:** Java: Como Programar — Cap. 17\n\n## Lambda — Função Anônima\n\n```java\n// Antes (Java 7)\nComparator<String> comp = new Comparator<String>() {\n    @Override\n    public int compare(String a, String b) { return a.compareTo(b); }\n};\n\n// Com Lambda (Java 8+)\nComparator<String> comp = (a, b) -> a.compareTo(b);\n\n// Ainda mais simples com Method Reference\nComparator<String> comp = String::compareTo;\n```\n\n## Interfaces Funcionais Principais\n\n| Interface | Método | Uso |\n|---|---|---|\n| Predicate<T> | test(T) → boolean | Filtrar |\n| Function<T,R> | apply(T) → R | Transformar |\n| Consumer<T> | accept(T) → void | Consumir |\n| Supplier<T> | get() → T | Produzir |\n| UnaryOperator<T> | apply(T) → T | Transformar mesmo tipo |\n\n## Stream Pipeline\n\n```java\nList<String> nomes = List.of("Ana", "Bruno", "Carlos", "Alice", "Ze");\n\nList<String> resultado = nomes.stream()\n    .filter(n -> n.length() > 3)        // Predicate\n    .map(String::toUpperCase)           // Function\n    .sorted()                           // Intermediária\n    .limit(3)                           // Intermediária\n    .collect(Collectors.toList());      // Terminal\n\n// [ALICE, BRUNO, CARLOS]\n```\n\n## Operações Terminais Úteis\n\n```java\n// Soma\nint total = numeros.stream().mapToInt(Integer::intValue).sum();\n\n// Agrupar por tamanho\nMap<Integer, List<String>> porTamanho = nomes.stream()\n    .collect(Collectors.groupingBy(String::length));\n\n// Encontrar máximo\nOptional<Integer> max = numeros.stream().max(Integer::compareTo);\n```',
 5);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(61, 46,
 'Pipeline de Streams com Estatísticas',
 'Processe uma lista de salários (doubles) usando Streams: (1) filtrarAcimaDe(List, double) — retorna salários > threshold ordenados crescente; (2) media(List) — retorna a média ou 0.0 se vazia; (3) totalImpostos(List, double) — soma imposto = salario * aliquota para salários > 3000.',
'import java.util.*;\nimport java.util.stream.*;\n\npublic class EstatisticasSalarios {\n\n    // Retorna salarios acima do threshold, ordenados crescente\n    public static List<Double> filtrarAcimaDe(List<Double> salarios, double threshold) {\n        return salarios.stream()\n            // .filter(...).sorted().collect(...)\n            .collect(Collectors.toList());\n    }\n\n    // Retorna a media dos salarios. 0.0 se lista vazia.\n    public static double media(List<Double> salarios) {\n        return 0.0;\n    }\n\n    // Soma imposto (salario * aliquota) apenas para salarios > 3000\n    public static double totalImpostos(List<Double> salarios, double aliquota) {\n        return 0.0;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.*;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class EstatisticasSalariosTest {\n    private final List<Double> salarios = List.of(1500.0, 3500.0, 2800.0, 5000.0, 900.0, 4200.0);\n\n    @Test\n    public void testFiltrar() {\n        List<Double> resultado = EstatisticasSalarios.filtrarAcimaDe(salarios, 3000.0);\n        assertEquals(List.of(3500.0, 4200.0, 5000.0), resultado);\n    }\n\n    @Test\n    public void testMedia() {\n        assertEquals(2983.33, EstatisticasSalarios.media(salarios), 0.01);\n        assertEquals(0.0, EstatisticasSalarios.media(List.of()), 0.001);\n    }\n\n    @Test\n    public void testImpostos() {\n        // 3500*0.15 + 5000*0.15 + 4200*0.15 = 525+750+630 = 1905\n        assertEquals(1905.0, EstatisticasSalarios.totalImpostos(salarios, 0.15), 0.001);\n    }\n\n    @Test\n    public void testListaVazia() {\n        assertEquals(0, EstatisticasSalarios.filtrarAcimaDe(List.of(), 1000).size());\n        assertEquals(0.0, EstatisticasSalarios.totalImpostos(List.of(), 0.15), 0.001);\n    }\n}',
 1, 'MEDIUM', 120,
 'filtrar: .filter(s->s>threshold).sorted().collect(toList()). media: stream().mapToDouble(Double::doubleValue).average().orElse(0.0). impostos: filter(s->s>3000).mapToDouble(s->s*aliquota).sum().');

-- ── Módulo 7.6: Threads e Concorrência ──────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(47, 7, 'Threads, Concorrência e ExecutorService',
 'Programação paralela em Java. Como executar tarefas simultaneamente com segurança.',
'# Threads e Concorrência\n\n**Livro:** Java: Como Programar — Cap. 23\n\n## Criando Threads\n\n```java\n// Opção 1: Runnable (recomendado)\nThread t = new Thread(() -> {\n    System.out.println("Rodando na thread: " + Thread.currentThread().getName());\n});\nt.start();\n\n// Opção 2: Extender Thread (menos flexível)\npublic class MinhaThread extends Thread {\n    @Override public void run() { /* código */ }\n}\n```\n\n## Problema: Condição de Corrida (Race Condition)\n\n```java\n// INSEGURO — múltiplas threads modificando contador\npublic class ContadorInseguro {\n    private int count = 0;\n    public void incrementar() { count++; } // NÃO atômico!\n}\n\n// SEGURO — synchronized\npublic class ContadorSeguro {\n    private int count = 0;\n    public synchronized void incrementar() { count++; }\n    public synchronized int getCount() { return count; }\n}\n\n// MAIS SIMPLES — AtomicInteger\nprivate AtomicInteger count = new AtomicInteger(0);\npublic void incrementar() { count.incrementAndGet(); }\n```\n\n## ExecutorService — O Jeito Profissional\n\n```java\nExecutorService executor = Executors.newFixedThreadPool(4);\n\nfor (int i = 0; i < 10; i++) {\n    final int tarefa = i;\n    executor.submit(() -> {\n        System.out.println("Tarefa " + tarefa);\n    });\n}\n\nexecutor.shutdown(); // para de aceitar novas tarefas\nexecutor.awaitTermination(30, TimeUnit.SECONDS);\n```\n\n## Future — Resultado Assíncrono\n\n```java\nFuture<Integer> resultado = executor.submit(() -> {\n    Thread.sleep(1000);\n    return 42;\n});\n\n// Bloqueia até ter o resultado\nSystem.out.println(resultado.get()); // 42\n```',
 6);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(62, 47,
 'Contador Thread-Safe com AtomicInteger',
 'Implemente um ContadorConcorrente thread-safe usando AtomicInteger. Métodos: incrementar(), decrementar(), resetar(), getValor(). O contador deve funcionar corretamente mesmo com múltiplas threads.',
'import java.util.concurrent.atomic.AtomicInteger;\n\npublic class ContadorConcorrente {\n    private AtomicInteger contador = new AtomicInteger(0);\n\n    public void incrementar() {\n        // Use incrementAndGet()\n    }\n\n    public void decrementar() {\n        // Use decrementAndGet()\n    }\n\n    public void resetar() {\n        // Use set(0)\n    }\n\n    public int getValor() {\n        // Use get()\n        return 0;\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.concurrent.*;\nimport java.util.concurrent.atomic.*;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class ContadorConcorrenteTest {\n    @Test\n    public void testIncrementar() {\n        ContadorConcorrente c = new ContadorConcorrente();\n        c.incrementar(); c.incrementar(); c.incrementar();\n        assertEquals(3, c.getValor());\n    }\n\n    @Test\n    public void testDecrementar() {\n        ContadorConcorrente c = new ContadorConcorrente();\n        c.incrementar(); c.incrementar();\n        c.decrementar();\n        assertEquals(1, c.getValor());\n    }\n\n    @Test\n    public void testResetar() {\n        ContadorConcorrente c = new ContadorConcorrente();\n        c.incrementar(); c.incrementar();\n        c.resetar();\n        assertEquals(0, c.getValor());\n    }\n\n    @Test\n    public void testConcorrencia() throws InterruptedException {\n        ContadorConcorrente c = new ContadorConcorrente();\n        ExecutorService exec = Executors.newFixedThreadPool(10);\n        for (int i = 0; i < 1000; i++) {\n            exec.submit(() -> c.incrementar());\n        }\n        exec.shutdown();\n        exec.awaitTermination(5, TimeUnit.SECONDS);\n        assertEquals(1000, c.getValor());\n    }\n}',
 1, 'HARD', 150,
 'incrementar: contador.incrementAndGet(); decrementar: contador.decrementAndGet(); resetar: contador.set(0); getValor: return contador.get(); O AtomicInteger garante atomicidade sem synchronized.');

-- ── Módulo 7.7: JDBC e Banco de Dados ───────────────────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(48, 7, 'JDBC, JPA e Acesso a Banco de Dados',
 'Do SQL puro com JDBC ao JPA/Hibernate. Como persistir dados em Java profissionalmente.',
'# JDBC e JPA\n\n**Livro:** Java: Como Programar — Cap. 24\n\n## JDBC — Baixo Nível\n\n```java\n// 1. Conectar\nConnection conn = DriverManager.getConnection(\n    "jdbc:postgresql://localhost/meubanco", "user", "pass");\n\n// 2. PreparedStatement (NUNCA concatene SQL — risco de SQL Injection!)\nPreparedStatement stmt = conn.prepareStatement(\n    "SELECT * FROM usuarios WHERE email = ? AND ativo = ?");\nstmt.setString(1, email);\nstmt.setBoolean(2, true);\n\n// 3. Executar\nResultSet rs = stmt.executeQuery();\nwhile (rs.next()) {\n    String nome = rs.getString("nome");\n    int idade  = rs.getInt("idade");\n}\n\n// 4. Fechar (use try-with-resources!)\n```\n\n## JPA/Spring Data — Alto Nível\n\n```java\n@Entity\n@Table(name = "produtos")\npublic class Produto {\n    @Id\n    @GeneratedValue(strategy = GenerationType.IDENTITY)\n    private Long id;\n\n    @Column(nullable = false, length = 100)\n    private String nome;\n\n    @Column(precision = 10, scale = 2)\n    private BigDecimal preco;\n}\n\n// Repository = CRUD pronto!\npublic interface ProdutoRepository extends JpaRepository<Produto, Long> {\n    List<Produto> findByNomeContainingIgnoreCase(String nome);\n    List<Produto> findByPrecoLessThan(BigDecimal limite);\n}\n```\n\n## SQL Injection — O Ataque Mais Comum\n\n```java\n// VULNERÁVEL: Concatenar entradas do usuário em queries SQL permite SQL Injection\n// SEGURO: Usar sempre PreparedStatement ou Spring Data JPA Repositories\n```\n\n## Transações\n\n```java\n@Transactional\npublic void transferir(Long deId, Long paraId, BigDecimal valor) {\n    // Se qualquer operação falhar, TUDO é revertido (rollback)\n    contaRepository.debitar(deId, valor);\n    contaRepository.creditar(paraId, valor);\n}\n```',
 7);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(63, 48,
 'DAO Pattern — Repository em memória',
 'Implemente o padrão DAO (Data Access Object) para Produto. ProdutoRepository deve manter produtos em um Map<Long,Produto> em memória: salvar(Produto), buscarPorId(Long) retorna Optional, listarTodos(), deletar(Long), buscarPorNome(String) retorna lista com nome contendo o termo (case-insensitive).',
'import java.util.*;\n\npublic class Produto {\n    private Long id;\n    private String nome;\n    private double preco;\n\n    public Produto(Long id, String nome, double preco) {\n        this.id = id; this.nome = nome; this.preco = preco;\n    }\n\n    public Long getId()      { return id; }\n    public String getNome()  { return nome; }\n    public double getPreco() { return preco; }\n}\n\npublic class ProdutoRepository {\n    private Map<Long, Produto> banco = new HashMap<>();\n    private long proximoId = 1;\n\n    // Salva produto. Se id==null, gera automaticamente.\n    public Produto salvar(Produto produto) {\n        return produto;\n    }\n\n    public Optional<Produto> buscarPorId(Long id) {\n        return Optional.empty();\n    }\n\n    public List<Produto> listarTodos() {\n        return new ArrayList<>();\n    }\n\n    public boolean deletar(Long id) {\n        return false;\n    }\n\n    // Busca por nome contendo o termo (case-insensitive)\n    public List<Produto> buscarPorNome(String termo) {\n        return new ArrayList<>();\n    }\n}',
'import org.junit.jupiter.api.Test;\nimport java.util.*;\nimport static org.junit.jupiter.api.Assertions.*;\n\npublic class ProdutoRepositoryTest {\n    @Test\n    public void testSalvarEBuscar() {\n        ProdutoRepository repo = new ProdutoRepository();\n        Produto p = repo.salvar(new Produto(null, "Notebook", 3500.0));\n        assertNotNull(p.getId());\n        Optional<Produto> encontrado = repo.buscarPorId(p.getId());\n        assertTrue(encontrado.isPresent());\n        assertEquals("Notebook", encontrado.get().getNome());\n    }\n\n    @Test\n    public void testListarTodos() {\n        ProdutoRepository repo = new ProdutoRepository();\n        repo.salvar(new Produto(null, "Mouse", 80.0));\n        repo.salvar(new Produto(null, "Teclado", 150.0));\n        assertEquals(2, repo.listarTodos().size());\n    }\n\n    @Test\n    public void testDeletar() {\n        ProdutoRepository repo = new ProdutoRepository();\n        Produto p = repo.salvar(new Produto(null, "Monitor", 1200.0));\n        assertTrue(repo.deletar(p.getId()));\n        assertFalse(repo.buscarPorId(p.getId()).isPresent());\n        assertFalse(repo.deletar(999L)); // nao existe\n    }\n\n    @Test\n    public void testBuscarPorNome() {\n        ProdutoRepository repo = new ProdutoRepository();\n        repo.salvar(new Produto(null, "Notebook Dell", 4000.0));\n        repo.salvar(new Produto(null, "Notebook Lenovo", 3500.0));\n        repo.salvar(new Produto(null, "Mouse", 80.0));\n        List<Produto> resultado = repo.buscarPorNome("notebook");\n        assertEquals(2, resultado.size());\n        assertEquals(0, repo.buscarPorNome("impressora").size());\n    }\n}',
 1, 'HARD', 150,
 'salvar: if(produto.getId()==null) use new Produto(proximoId++,...). buscarPorId: Optional.ofNullable(banco.get(id)). deletar: return banco.remove(id)!=null. buscarPorNome: valores().stream().filter(p->p.getNome().toLowerCase().contains(termo.toLowerCase())).collect(toList()).');

-- Quizzes Trilha 7
INSERT INTO quizzes (id, modulo_id, pergunta, ordem) VALUES
(58, 42, 'Qual palavra-chave é usada para chamar o construtor da superclasse em Java?', 1),
(59, 43, 'Qual interface deve ser implementada para que objetos sejam ordenáveis pelo Collections.sort()?', 1),
(60, 44, 'Qual a diferença entre Checked Exception e Unchecked Exception?', 1),
(61, 45, 'Qual é a vantagem principal do uso de Generics em Java?', 1),
(62, 46, 'Qual operação terminal do Stream coleta os resultados em uma List?', 1),
(63, 47, 'Por que AtomicInteger é preferível a int++ em código concorrente?', 1),
(64, 48, 'Por que é OBRIGATÓRIO usar PreparedStatement em vez de concatenar SQL com String?', 1);

INSERT INTO quiz_opcoes (id, quiz_id, texto_opcao, is_correta) VALUES
-- Q58: super
(229, 58, 'parent()', false),
(230, 58, 'super()', true),
(231, 58, 'base()', false),
(232, 58, 'extends()', false),
-- Q59: Comparable
(233, 59, 'Serializable', false),
(234, 59, 'Comparable<T>', true),
(235, 59, 'Sortable', false),
(236, 59, 'Ordered', false),
-- Q60: Checked vs Unchecked
(237, 60, 'São a mesma coisa, apenas nomes diferentes', false),
(238, 60, 'Checked deve ser declarada/capturada em compile time; Unchecked (RuntimeException) é opcional', true),
(239, 60, 'Unchecked não pode ser capturada', false),
(240, 60, 'Checked só ocorre em produção', false),
-- Q61: Generics
(241, 61, 'Execução mais rápida', false),
(242, 61, 'Type safety em compile time, eliminando ClassCastException em runtime', true),
(243, 61, 'Permite herança múltipla', false),
(244, 61, 'Reduz o uso de memória', false),
-- Q62: collect
(245, 62, '.toArray()', false),
(246, 62, '.collect(Collectors.toList())', true),
(247, 62, '.forEach()', false),
(248, 62, '.reduce()', false),
-- Q63: AtomicInteger
(249, 63, 'AtomicInteger é mais rápido em single-thread', false),
(250, 63, 'int++ não é atômico — pode ser interrompido entre leitura e escrita, causando race condition', true),
(251, 63, 'int++ não compila em código multithreaded', false),
(252, 63, 'AtomicInteger usa menos memória', false),
-- Q64: PreparedStatement
(253, 64, 'PreparedStatement é mais lento mas mais legível', false),
(254, 64, 'Concatenar SQL permite SQL Injection, onde o atacante pode executar SQL arbitrário', true),
(255, 64, 'Concatenar SQL não funciona em todos os bancos', false),
(256, 64, 'É apenas uma convenção de código', false);
