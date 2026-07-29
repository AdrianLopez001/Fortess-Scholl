-- ============================================================
-- V7 — Trilha 8: Automação & Engenharia de Redes com Python (Projeto NetWatch)
-- ============================================================
-- Projeto Evolutivo: "NetWatch" - Sistema de Monitoramento e Automação de Redes
-- Níveis: Iniciante, Intermediário e Avançado
-- Linguagem Principal: Python 3
-- ============================================================

INSERT INTO trilhas (id, titulo, descricao, nivel, ordem) VALUES
(8, 'NetWatch — Automação & Monitoramento de Redes com Python',
 'Projeto evolutivo completo: construa do zero o NetWatch, um sistema de monitoramento de infraestrutura em Python. Da verificação de IP/Ping a scanners multithread, automação SSH de roteadores e motor de alertas/diagnóstico.',
 'PLENO', 8);

-- ============================================================
-- NÍVEL INICIANTE — FUNDAMENTOS DE REDES & NETWATCH CORE
-- ============================================================

-- ── Módulo 8.1: NetWatch Core v1 — IP, Gateway e DNS (Iniciante) ──
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(49, 8, 'NetWatch Core v1.0 — IP, Gateway e DNS',
 'Aprenda os fundamentos de redes TCP/IP e construa o módulo inicial do NetWatch para identificar IP, Gateway e DNS.',
'# NetWatch Core v1.0 — Informações de Rede

**Nível:** Iniciante | **Linguagem:** Python | **Projeto:** NetWatch

## O Projeto NetWatch

O **NetWatch** é o seu sistema de monitoramento de redes em Python. A cada módulo, você adicionará novas funcionalidades até transformar o NetWatch em uma plataforma completa de monitoramento e automação de infraestrutura.

## Fundamentos de TCP/IP no NetWatch

1. **Endereço IP:** Identificador único de uma máquina na rede.
2. **Gateway:** O roteador que conecta a rede local à internet.
3. **DNS:** Servidor que traduz nomes de domínio (ex: google.com) em IPs.

## Verificando Hostnames e IPs em Python

```python
import socket

def obter_info_host():
    hostname = socket.gethostname()
    ip_local = socket.gethostbyname(hostname)
    return {
        "hostname": hostname,
        "ip_local": ip_local
    }
```

## Resolução DNS com Socket

```python
def resolver_dns(domain):
    try:
        ip = socket.gethostbyname(domain)
        return {"domain": domain, "ip": ip, "status": "RESOLVED"}
    except socket.gaierror:
        return {"domain": domain, "ip": None, "status": "FAILED"}
```',
 1);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(64, 49,
 'NetWatch Module 1 — Coletor de IP e DNS',
 'Implemente `netwatch_info_rede(hostname_ou_ip)` em Python. A função deve retornar um dicionário com: "host" (str), "ip" (str resolvido pelo socket ou o próprio IP), e "online" (bool, True se conseguir resolver o IP). Se falhar a resolução, retorne "ip": None e "online": False.',
'import socket

def netwatch_info_rede(target: str) -> dict:
    """
    Função do NetWatch v1.0.
    Tenta resolver o IP do target usando socket.gethostbyname.
    Retorna: {"host": target, "ip": ip_resolvido, "online": True/False}
    """
    # Use socket.gethostbyname dentro de try/except socket.gaierror
    return {}
',
'import unittest
from solution import netwatch_info_rede

class TestNetWatchInfoRede(unittest.TestCase):
    def test_localhost(self):
        r = netwatch_info_rede("127.0.0.1")
        self.assertEqual("127.0.0.1", r["host"])
        self.assertEqual("127.0.0.1", r["ip"])
        self.assertTrue(r["online"])

    def test_domain_invalido(self):
        r = netwatch_info_rede("domain.invalido.nao.existe.xyz")
        self.assertFalse(r["online"])
        self.assertIsNone(r["ip"])

if __name__ == "__main__":
    unittest.main()
',
 1, 'EASY', 100,
 'try: ip = socket.gethostbyname(target); return {"host": target, "ip": ip, "online": True} except (socket.gaierror, OSError): return {"host": target, "ip": None, "online": False}');

-- ── Módulo 8.2: NetWatch Ping Engine & Conectividade (Iniciante) ──
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(50, 8, 'NetWatch Ping Engine — Testes de Conectividade',
 'Implemente o motor de verificações de conectividade e testes de resposta de servidores no NetWatch.',
'# NetWatch Ping Engine — Teste de Conectividade

**Nível:** Iniciante | **Linguagem:** Python | **Projeto:** NetWatch

## Verificando Conectividade no NetWatch

Para saber se um host ou servidor está online, o NetWatch utiliza testes de conectividade via Sockets TCP/IP.

```python
import socket
import time

def ping_tcp(host, porta=80, timeout=1.5):
    inicio = time.time()
    try:
        with socket.create_connection((host, porta), timeout=timeout):
            latencia_ms = round((time.time() - inicio) * 1000, 2)
            return {
                "host": host,
                "status": "ONLINE",
                "latencia_ms": latencia_ms
            }
    except (socket.timeout, ConnectionRefusedError, OSError):
        return {
            "host": host,
            "status": "OFFLINE",
            "latencia_ms": -1
        }
```

## Monitorando uma Lista de Servidores

```python
servidores = ["127.0.0.1", "8.8.8.8", "1.1.1.1"]
resultados = [ping_tcp(s) for s in servidores]
```',
 2);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(65, 50,
 'NetWatch Module 2 — Motor de Ping TCP',
 'Implemente `netwatch_ping(host, porta, timeout)` em Python. Tente conectar com `socket.create_connection`. Se conectar, retorne `{"host": host, "status": "ONLINE", "latencia_ms": float}`. Se falhar, retorne `{"host": host, "status": "OFFLINE", "latencia_ms": -1.0}`.',
'import socket
import time

def netwatch_ping(host: str, porta: int = 80, timeout: float = 1.0) -> dict:
    """
    Mede a conectividade e latencia de um host no NetWatch.
    """
    # Calcule a latencia usando time.time() antes e depois da conexao
    return {}
',
'import unittest
from solution import netwatch_ping

class TestNetWatchPing(unittest.TestCase):
    def test_offline_host(self):
        res = netwatch_ping("127.0.0.1", 59999, timeout=0.2)
        self.assertEqual("OFFLINE", res["status"])
        self.assertEqual(-1.0, res["latencia_ms"])

    def test_estrutura_retorno(self):
        res = netwatch_ping("127.0.0.1", 80, timeout=0.1)
        self.assertIn("host", res)
        self.assertIn("status", res)
        self.assertIn("latencia_ms", res)

if __name__ == "__main__":
    unittest.main()
',
 1, 'EASY', 100,
 't0 = time.time(); try: with socket.create_connection((host, porta), timeout=timeout): lat = round((time.time()-t0)*1000, 2); return {"host": host, "status": "ONLINE", "latencia_ms": lat} except Exception: return {"host": host, "status": "OFFLINE", "latencia_ms": -1.0}');

-- ============================================================
-- NÍVEL INTERMEDIÁRIO — VARREDURAS, SUBNET & SCANNERS
-- ============================================================

-- ── Módulo 8.3: NetWatch Subnet Scanner (Intermediário) ────────
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(51, 8, 'NetWatch Subnet Scanner — Varredura de Sub-rede',
 'Evolua o NetWatch para realizar varreduras de IP na rede local e contar dispositivos ativos.',
'# NetWatch Subnet Scanner

**Nível:** Intermediário | **Linguagem:** Python | **Projeto:** NetWatch

## Varredura de Sub-rede no NetWatch

Para mapear todos os dispositivos ativos em um segmento de rede (ex: `192.168.1.0/24`), o NetWatch faz uma varredura sequencial ou concorrente nos endereços IP da faixa.

```python
import ipaddress

def gerar_ips_subrede(cidr):
    rede = ipaddress.ip_network(cidr, strict=False)
    return [str(ip) for ip in rede.hosts()]
```

## Mapeando Dispositivos Ativos

```python
def escanear_subrede(cidr, porta=80, timeout=0.2):
    ips = gerar_ips_subrede(cidr)
    ativos = []
    for ip in ips:
        res = ping_tcp(ip, porta, timeout)
        if res["status"] == "ONLINE":
            ativos.append(ip)
    return {
        "cidr": cidr,
        "total_verificados": len(ips),
        "dispositivos_ativos": ativos,
        "total_ativos": len(ativos)
    }
```',
 3);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(66, 51,
 'NetWatch Module 3 — Scanner de Sub-rede',
 'Implemente `netwatch_scan_subrede(lista_ips, mapa_status)` em Python. Dada uma lista de IPs e um dicionário `mapa_status` com `{ip: True/False}`, retorne um dict com: "total_verificados" (int), "dispositivos_ativos" (lista de IPs onde status==True), e "percentual_online" (float arredondado com 1 casa decimal).',
'def netwatch_scan_subrede(lista_ips: list, mapa_status: dict) -> dict:
    """
    Processa a varredura da sub-rede no NetWatch.
    mapa_status e um dicionario {ip: True/False}
    """
    # Filtre os ativos e calcule o percentual online
    return {}
',
'import unittest
from solution import netwatch_scan_subrede

class TestNetWatchSubnet(unittest.TestCase):
    def test_scan_subrede(self):
        ips = ["192.168.1.1", "192.168.1.2", "192.168.1.3", "192.168.1.4"]
        status = {"192.168.1.1": True, "192.168.1.2": False, "192.168.1.3": True, "192.168.1.4": False}
        res = netwatch_scan_subrede(ips, status)
        self.assertEqual(4, res["total_verificados"])
        self.assertEqual(["192.168.1.1", "192.168.1.3"], res["dispositivos_ativos"])
        self.assertEqual(50.0, res["percentual_online"])

if __name__ == "__main__":
    unittest.main()
',
 1, 'MEDIUM', 120,
 'ativos = [ip for ip in lista_ips if mapa_status.get(ip, False)]; pct = round(len(ativos)/len(lista_ips)*100, 1) if lista_ips else 0.0; return {"total_verificados": len(lista_ips), "dispositivos_ativos": ativos, "percentual_online": pct}');

-- ── Módulo 8.4: NetWatch Multi-Thread Port Scanner & Histórico (Intermediário) ──
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(52, 8, 'NetWatch Multi-Thread Scanner & Relatórios',
 'Adicione Threads para aceleração de varredura e gerador de relatórios históricos em JSON no NetWatch.',
'# NetWatch Multi-Thread Scanner & Histórico

**Nível:** Intermediário | **Linguagem:** Python | **Projeto:** NetWatch

## Varredura Concorrente com Threads

Varrer centenas de portas sequencialmente pode levar minutos. Com `concurrent.futures`, o NetWatch executa verificações simultâneas em segundos.

```python
from concurrent.futures import ThreadPoolExecutor
import socket

def checar_porta(host, porta):
    try:
        with socket.create_connection((host, porta), timeout=0.5):
            return porta
    except Exception:
        return None

def escanear_portas_rapido(host, portas_lista, max_threads=20):
    portas_abertas = []
    with ThreadPoolExecutor(max_workers=max_threads) as executor:
        resultados = executor.map(lambda p: checar_porta(host, p), portas_lista)
        portas_abertas = [p for p in resultados if p is not None]
    return portas_abertas
```

## Registro de Histórico em JSON

```python
import json
from datetime import datetime

def salvar_historico_netwatch(dados_auditoria, arquivo="netwatch_history.json"):
    registro = {
        "timestamp": datetime.now().isoformat(),
        "dados": dados_auditoria
    }
    with open(arquivo, "a") as f:
        f.write(json.dumps(registro) + "\n")
```',
 4);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(67, 52,
 'NetWatch Module 4 — Relatório Histórico de Auditoria',
 'Implemente `netwatch_gerar_relatorio(host, portas_abertas, latencia_ms)` em Python. Retorne um dict com: "host", "portas_abertas" (lista ordenada), "quantidade_portas" (int), "latencia_ms", e "status_geral" ("SAUDAVEL" se latencia <= 100 e len(portas_abertas) > 0, senão "ATENCAO").',
'def netwatch_gerar_relatorio(host: str, portas_abertas: list, latencia_ms: float) -> dict:
    """
    Gera o relatorio de auditoria do NetWatch v2.0.
    """
    # Ordene as portas abertas e defina o status_geral
    return {}
',
'import unittest
from solution import netwatch_gerar_relatorio

class TestNetWatchRelatorio(unittest.TestCase):
    def test_relatorio_saudavel(self):
        res = netwatch_gerar_relatorio("192.168.1.1", [443, 80, 22], 15.5)
        self.assertEqual("192.168.1.1", res["host"])
        self.assertEqual([22, 80, 443], res["portas_abertas"])
        self.assertEqual(3, res["quantidade_portas"])
        self.assertEqual("SAUDAVEL", res["status_geral"])

    def test_relatorio_atencao(self):
        res = netwatch_gerar_relatorio("10.0.0.1", [80], 150.0)
        self.assertEqual("ATENCAO", res["status_geral"])

if __name__ == "__main__":
    unittest.main()
',
 1, 'MEDIUM', 120,
 'portas_ord = sorted(portas_abertas); st = "SAUDAVEL" if latencia_ms <= 100 and len(portas_ord) > 0 else "ATENCAO"; return {"host": host, "portas_abertas": portas_ord, "quantidade_portas": len(portas_ord), "latencia_ms": latencia_ms, "status_geral": st}');

-- ============================================================
-- NÍVEL AVANÇADO — AUTOMATION SSH, DIAGNOSIS & ALERTS
-- ============================================================

-- ── Módulo 8.5: NetWatch SSH Automação & Ações Remotas (Avançado) ──
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(53, 8, 'NetWatch SSH Action Engine — Automação de Roteadores',
 'Implemente o módulo de ações automatizadas do NetWatch para executar comandos SSH e aplicar alterações em equipamentos.',
'# NetWatch SSH Action Engine

**Nível:** Avançado | **Linguagem:** Python | **Projeto:** NetWatch

## Ações Automatizadas em Equipamentos de Rede

No nível avançado, o NetWatch deixa de ser apenas um monitor passivo e passa a **executar ações de remediação** em switches, roteadores e servidores via SSH.

```python
# Conexão SSH para execução de comandos remotos
def executar_comando_ssh_simulado(host, comando, credenciais):
    # Valida credenciais e envia comando via SSH
    if credenciais.get("password") == "secret":
        return {"status": "SUCCESS", "output": f"Comando {comando} executado no {host}"}
    return {"status": "AUTH_FAILED", "output": "Falha de autenticação SSH"}
```

## Casos de Uso de Ações Automáticas no NetWatch

1. **Reiniciar Serviço:** Reiniciar um daemon de roteamento (ex: BGP/OSPF) se o peer cair.
2. **Isolar Porta:** Desativar uma porta de switch (shutdown) ao detectar invasão.
3. **Limpar Cache:** Flush na tabela ARP ao detectar conflito de IP.',
 5);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(68, 53,
 'NetWatch Module 5 — Executor de Ações SSH',
 'Implemente `netwatch_executar_acao(host, acao, autorizado)` em Python. Ações válidas: "REINICIAR_SERVICO", "APLICAR_VLAN", "FLUSH_ARP". Se `autorizado` for False, retorne `{"status": "NEGADO", "mensagem": "Acao nao autorizada pelo administrador"}`. Se ação for inválida, lance `ValueError("Acao desconhecida")`. Se autorizada, retorne `{"status": "EXECUTADO", "host": host, "acao": acao}`.',
'def netwatch_executar_acao(host: str, acao: str, autorizado: bool = False) -> dict:
    """
    Executor de acoes remotas de remediacao do NetWatch.
    """
    acoes_validas = {"REINICIAR_SERVICO", "APLICAR_VLAN", "FLUSH_ARP"}
    # Valide se acao esta em acoes_validas (senao ValueError)
    # Valide autorizacao e monte o retorno
    return {}
',
'import unittest
from solution import netwatch_executar_acao

class TestNetWatchActionEngine(unittest.TestCase):
    def test_acao_executada(self):
        r = netwatch_executar_acao("192.168.1.1", "FLUSH_ARP", autorizado=True)
        self.assertEqual("EXECUTADO", r["status"])
        self.assertEqual("192.168.1.1", r["host"])
        self.assertEqual("FLUSH_ARP", r["acao"])

    def test_acao_nao_autorizada(self):
        r = netwatch_executar_acao("192.168.1.1", "REINICIAR_SERVICO", autorizado=False)
        self.assertEqual("NEGADO", r["status"])

    def test_acao_invalida(self):
        with self.assertRaises(ValueError):
            netwatch_executar_acao("192.168.1.1", "DELETAR_TUDO", autorizado=True)

if __name__ == "__main__":
    unittest.main()
',
 1, 'HARD', 150,
 'if acao not in acoes_validas: raise ValueError("Acao desconhecida"); if not autorizado: return {"status": "NEGADO", "mensagem": "Acao nao autorizada pelo administrador"}; return {"status": "EXECUTADO", "host": host, "acao": acao}');

-- ── Módulo 8.6: NetWatch Diagnóstico de Falhas & Motor de Alertas (Avançado) ──
INSERT INTO modulos (id, trilha_id, titulo, descricao, conteudo_markdown, ordem) VALUES
(54, 8, 'NetWatch Diagnosis & Alert Engine',
 'Construa o motor inteligente do NetWatch que diagnostica a causa raiz de falhas e dispara alertas para Discord/Telegram.',
'# NetWatch Diagnosis & Alert Engine

**Nível:** Avançado | **Linguagem:** Python | **Projeto:** NetWatch

## Diagnóstico Inteligente de Falhas

O NetWatch analisa métricas de CPU, memória e perda de pacotes para inferir a **causa provável** da falha de infraestrutura:

```python
def diagnosticar_falha(cpu_pct, memoria_pct, perda_pacotes_pct):
    causas = []
    if perda_pacotes_pct > 20.0:
        causas.append("Instabilidade no link físico ou saturação da interface")
    if cpu_pct > 85.0:
        causas.append("Sobrecarga de processamento no equipamento (CPU High)")
    if memoria_pct > 90.0:
        causas.append("Vazamento de memória ou esgotamento de RAM (Memory Leak)")
    
    return {
        "status": "CRITICO" if causas else "NORMAL",
        "causas_provaveis": causas if causas else ["Nenhuma falha detectada"]
    }
```

## Motor de Alertas via Webhooks (Discord / Telegram)

```python
import json
import urllib.request

def enviar_alerta_webhook(webhook_url, mensagem_alerta):
    payload = json.dumps({"content": f"🚨 **NetWatch Alert:** {mensagem_alerta}"}).encode("utf-8")
    req = urllib.request.Request(webhook_url, data=payload, headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=2.0) as resp:
            return resp.status == 204 or resp.status == 200
    except Exception:
        return False
```',
 6);

INSERT INTO exercicios (id, modulo_id, titulo, enunciado, codigo_template, testes_junit_code, ordem, nivel_dificuldade, pontos_base, dica_hint) VALUES
(69, 54,
 'NetWatch Module 6 — Diagnóstico de Causa Raiz e Alertas',
 'Implemente `netwatch_diagnosticar_e_alertar(device_name, cpu_pct, loss_pct)` em Python. Regras: se `cpu_pct > 80`, causa = "CPU Overload"; se `loss_pct > 10`, causa = "Packet Loss"; se ambos, retorne ambas as causas. Se nenhuma, causa = "System Normal". Retorne dict `{"device": device_name, "severidade": "ALTA"/"NORMAL", "causas": [lista_de_causas], "alerta_gerado": True/False}` (alerta_gerado é True se severidade=="ALTA").',
'def netwatch_diagnosticar_e_alertar(device_name: str, cpu_pct: float, loss_pct: float) -> dict:
    """
    Motor de Diagnostico e Alertas do NetWatch v3.0.
    """
    # Determine as causas, severidade e alerta_gerado
    return {}
',
'import unittest
from solution import netwatch_diagnosticar_e_alertar

class TestNetWatchDiagnosis(unittest.TestCase):
    def test_sistema_normal(self):
        r = netwatch_diagnosticar_e_alertar("Router-Core", 35.0, 0.0)
        self.assertEqual("NORMAL", r["severidade"])
        self.assertEqual(["System Normal"], r["causas"])
        self.assertFalse(r["alerta_gerado"])

    def test_cpu_overload(self):
        r = netwatch_diagnosticar_e_alertar("Switch-Acc-01", 92.0, 2.0)
        self.assertEqual("ALTA", r["severidade"])
        self.assertEqual(["CPU Overload"], r["causas"])
        self.assertTrue(r["alerta_gerado"])

    def test_multiplas_causas(self):
        r = netwatch_diagnosticar_e_alertar("Firewall-FW01", 88.0, 25.0)
        self.assertEqual("ALTA", r["severidade"])
        self.assertEqual(["CPU Overload", "Packet Loss"], r["causas"])
        self.assertTrue(r["alerta_gerado"])

if __name__ == "__main__":
    unittest.main()
',
 1, 'HARD', 150,
 'causas = []; if cpu_pct > 80: causas.append("CPU Overload"); if loss_pct > 10: causas.append("Packet Loss"); sev = "ALTA" if causas else "NORMAL"; if not causas: causas = ["System Normal"]; return {"device": device_name, "severidade": sev, "causas": causas, "alerta_gerado": sev == "ALTA"}');

-- Quizzes Trilha 8
INSERT INTO quizzes (id, modulo_id, pergunta, ordem) VALUES
(65, 49, 'Qual o papel da biblioteca socket do Python no projeto NetWatch?', 1),
(66, 50, 'No NetWatch, como calculamos a latência de conectividade de um host?', 1),
(67, 51, 'Qual a principal vantagem da varredura de sub-rede no NetWatch Intermediário?', 1),
(68, 52, 'Por que utilizamos ThreadPoolExecutor na varredura de portas do NetWatch?', 1),
(69, 53, 'Qual a função do módulo SSH Action Engine no NetWatch Avançado?', 1),
(70, 54, 'Como o NetWatch Avançado identifica a causa provável de uma falha de infraestrutura?', 1);

INSERT INTO quiz_opcoes (id, quiz_id, texto_opcao, is_correta) VALUES
-- Q65: Socket NetWatch
(257, 65, 'Criar interfaces gráficas para o usuário', false),
(258, 65, 'Fornecer a API de comunicação de baixo nível para resolução DNS, verificações IP e sockets TCP/UDP', true),
(259, 65, 'Editar arquivos de texto', false),
(260, 65, 'Gerar relatórios em PDF', false),
-- Q66: Latencia
(261, 66, 'Medindo a diferença de tempo antes e depois da abertura bem-sucedida do socket TCP', true),
(262, 66, 'Contando o número de caracteres do IP', false),
(263, 66, 'Dividindo o endereço IP pela porta', false),
(264, 66, 'Consultando o relógio do sistema operacional sem fazer conexão', false),
-- Q67: Subnet advantage
(265, 67, 'Descobrir automaticamente quais endereços IP têm dispositivos ativos na rede local', true),
(266, 67, 'Desligar os roteadores da rede', false),
(267, 67, 'Formatar o disco rígido dos servidores', false),
(268, 67, 'Alterar as senhas do Wi-Fi', false),
-- Q68: ThreadPoolExecutor
(269, 68, 'Para executar as verificações de portas concorrentemente em paralelo, reduzindo drasticamente o tempo total', true),
(270, 68, 'Para economizar espaço em disco', false),
(271, 68, 'Para evitar a necessidade de declarar variáveis em Python', false),
(272, 68, 'Para criptografar os dados em SSL automaticamente', false),
-- Q69: SSH Action Engine
(273, 69, 'Executar comandos remotos de remediação e configuração em switches e roteadores via SSH', true),
(274, 69, 'Limpar a lixeira do Windows', false),
(275, 69, 'Desenhar diagramas de rede em PNG', false),
(276, 69, 'Tocar um alarme de som no alto-falante', false),
-- Q70: Diagnosis Engine
(277, 70, 'Analisando o cruzamento de métricas como CPU, memória e perda de pacotes contra limiares críticos', true),
(278, 70, 'Gerando números aleatórios entre 1 e 10', false),
(279, 70, 'Consultando o nome do arquivo', false),
(280, 70, 'Perguntando ao usuário via terminal', false);
