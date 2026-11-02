# Chatbot WhatsApp IMPORPLAY

Chatbot de atendimento para WhatsApp usando Evolution API, n8n, PostgreSQL e Redis.

O fluxo oferece:

- Menu principal de atendimento.
- Informações sobre planos.
- Teste grátis.
- Suporte técnico.
- Transferência para atendimento humano.
- Pausa automática do bot durante o atendimento humano.
- Finalização do atendimento com a mensagem `finalizar`.

## Pré-requisitos

- Windows, Linux ou macOS.
- Docker Desktop com Docker Compose.
- WhatsApp disponível para escanear o QR Code.
- Uma porta livre para:
  - Evolution API: `8080`
  - n8n: `5678`

## 1. Clonar o projeto

```bash
git clone https://github.com/Damascenopog/Chatbot.git
cd Chatbot
```

## 2. Configurar as variáveis de ambiente

No Windows PowerShell:

```powershell
Copy-Item .env.example .env
notepad .env
```

No Linux/macOS:

```bash
cp .env.example .env
nano .env
```

Preencha pelo menos estas variáveis:

```dotenv
POSTGRES_USER=evolution
POSTGRES_PASSWORD=use-uma-senha-forte
POSTGRES_DB=evolution

EVOLUTION_SERVER_URL=http://localhost:8080
EVOLUTION_API_KEY=gere-uma-chave-aleatoria

N8N_HOST=localhost
N8N_WEBHOOK_URL=http://localhost:5678/
N8N_ENCRYPTION_KEY=gere-uma-chave-aleatoria-diferente

NOME_EMPRESA=IMPORPLAY
WHATSAPP_ATENDENTE=5511999999999
```

Nunca publique o arquivo `.env`. Ele está protegido pelo `.gitignore`.

## 3. Iniciar os serviços

```bash
docker compose up -d
```

Verifique se os containers estão rodando:

```bash
docker compose ps
```

Acesse:

- Evolution API: <http://localhost:8080>
- n8n: <http://localhost:5678>

## 4. Criar e conectar a instância do WhatsApp

Defina a chave da API na sessão atual do PowerShell:

```powershell
$env:EVOLUTION_API_KEY = "a-mesma-chave-do-arquivo-.env"
```

Execute o script de configuração:

```powershell
.\setup-evolution.ps1
```

Alternativamente, abra no navegador:

```text
http://localhost:8080/instance/connect/chatbot-filmes
```

No WhatsApp do celular:

1. Abra **Configurações**.
2. Entre em **Aparelhos conectados**.
3. Escolha **Conectar um aparelho**.
4. Escaneie o QR Code exibido.

Confirme o estado da conexão:

```powershell
.\check-status.ps1
```

O estado esperado é `open`.

## 5. Importar o workflow no n8n

1. Abra <http://localhost:5678>.
2. Acesse **Workflows**.
3. Escolha **Import from File**.
4. Selecione `n8n-workflow-chatbot.json`.
5. Salve o workflow.
6. Ative o workflow usando o botão de ativação.

O webhook de produção será:

```text
http://localhost:5678/webhook/whatsapp-webhook
```

O workflow envia mensagens para a Evolution API usando o nome da instância `chatbot-filmes`.

## 6. Configurar o webhook da Evolution API

Se o webhook não for configurado automaticamente, execute:

```powershell
.\set-webhook.ps1
```

O endereço usado entre os containers é:

```text
http://n8n:5678/webhook/whatsapp-webhook
```

## 7. Testar

Teste o webhook diretamente:

```powershell
.\test-webhook.ps1
```

Teste a API e a autenticação:

```powershell
.\test-api.ps1
.\test-auth.ps1
```

Envie uma mensagem para o WhatsApp conectado. O bot deve exibir o menu e responder às opções `1`, `2`, `3` e `4`.

## Atendimento humano

Quando o cliente escolher `4`, o bot registra o contato em atendimento humano e deixa de responder às mensagens desse contato.

O atendimento pode ser encerrado pelo cliente ou pelo atendente enviando exatamente:

```text
finalizar
```

Depois disso, o workflow envia uma confirmação, agradece a preferência e volta a processar novas mensagens do contato.

## Comandos úteis

Ver logs:

```bash
docker compose logs -f n8n
docker compose logs -f evolution-api
```

Reiniciar os serviços:

```bash
docker compose restart
```

Parar os serviços:

```bash
docker compose down
```

Parar e remover os volumes persistentes, apagando dados locais:

```bash
docker compose down -v
```

Use o último comando somente se quiser recriar o banco, a sessão do WhatsApp e os dados do n8n.

## Estrutura principal

| Arquivo | Finalidade |
|---|---|
| `docker-compose.yml` | Define Evolution API, n8n, PostgreSQL e Redis |
| `n8n-workflow-chatbot.json` | Workflow importável no n8n |
| `.env.example` | Modelo das variáveis de ambiente |
| `setup-evolution.ps1` | Cria/configura a instância e o webhook |
| `gerar-qrcode.ps1` | Auxilia na conexão do WhatsApp |
| `test-webhook.ps1` | Envia um payload de teste ao n8n |

## Segurança

- Troque todas as chaves e senhas antes de usar em produção.
- Não versione `.env`, tokens, QR Codes ou dados de sessão.
- Não exponha as portas `8080` e `5678` publicamente sem autenticação e proxy seguro.
- Faça backup dos volumes Docker antes de atualizações.
