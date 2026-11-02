# Chatbot WhatsApp - CineApp (App de Filmes para TV)
# Script auxiliar para configuração inicial da Evolution API
# Execute após os containers estarem rodando

# ============================================
# CONFIGURAÇÕES - Altere conforme necessário
# ============================================
$EVOLUTION_URL = "http://localhost:8080"
$API_KEY = $env:EVOLUTION_API_KEY
$INSTANCE_NAME = "chatbot-filmes"
$N8N_WEBHOOK_URL = "http://n8n:5678/webhook/whatsapp-webhook"

$headers = @{
    "apikey"       = $API_KEY
    "Content-Type" = "application/json"
}

# ============================================
# 1. Criar instância do WhatsApp
# ============================================
Write-Host "`n🔧 Criando instância '$INSTANCE_NAME'..." -ForegroundColor Cyan

$createBody = @{
    instanceName = $INSTANCE_NAME
    integration  = "WHATSAPP-BAILEYS"
    qrcode       = $true
    rejectCall   = $true
    msgCall      = "Não recebemos ligações. Por favor, envie uma mensagem de texto."
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$EVOLUTION_URL/instance/create" -Method Post -Headers $headers -Body $createBody
    Write-Host "✅ Instância criada com sucesso!" -ForegroundColor Green
    Write-Host ($response | ConvertTo-Json -Depth 5)
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "⚠️  Instância já existe. Continuando..." -ForegroundColor Yellow
    } else {
        Write-Host "❌ Erro ao criar instância: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ============================================
# 2. Obter QR Code para conectar WhatsApp
# ============================================
Write-Host "`n📱 Obtendo QR Code..." -ForegroundColor Cyan
Write-Host "Abra o link abaixo no navegador para escanear o QR Code:" -ForegroundColor Yellow
Write-Host "  👉 $EVOLUTION_URL/instance/connect/$INSTANCE_NAME" -ForegroundColor White
Write-Host ""
Write-Host "No WhatsApp do celular:" -ForegroundColor Yellow
Write-Host "  1. Vá em Configurações > Aparelhos Conectados" -ForegroundColor White
Write-Host "  2. Toque em 'Conectar um aparelho'" -ForegroundColor White
Write-Host "  3. Escaneie o QR Code exibido" -ForegroundColor White

# ============================================
# 3. Configurar Webhook para n8n
# ============================================
Write-Host "`n🔗 Configurando webhook para n8n..." -ForegroundColor Cyan

$webhookBody = @{
    url              = $N8N_WEBHOOK_URL
    webhook_by_events = $false
    events           = @(
        "MESSAGES_UPSERT"
    )
} | ConvertTo-Json

# Aguardar um pouco para a instância estar pronta
Start-Sleep -Seconds 3

try {
    $response = Invoke-RestMethod -Uri "$EVOLUTION_URL/webhook/set/$INSTANCE_NAME" -Method Post -Headers $headers -Body $webhookBody
    Write-Host "✅ Webhook configurado!" -ForegroundColor Green
    Write-Host "   URL: $N8N_WEBHOOK_URL" -ForegroundColor White
} catch {
    Write-Host "❌ Erro ao configurar webhook: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Tente novamente após conectar o WhatsApp via QR Code" -ForegroundColor Yellow
}

# ============================================
# Resumo
# ============================================
Write-Host "`n" -NoNewline
Write-Host "=" * 50 -ForegroundColor DarkGray
Write-Host "📋 RESUMO DA CONFIGURAÇÃO" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor DarkGray
Write-Host "  Evolution API:  $EVOLUTION_URL" -ForegroundColor White
Write-Host "  n8n:            http://localhost:5678" -ForegroundColor White
Write-Host "  Instância:      $INSTANCE_NAME" -ForegroundColor White
Write-Host "  QR Code:        $EVOLUTION_URL/instance/connect/$INSTANCE_NAME" -ForegroundColor White
Write-Host "  Webhook:        $N8N_WEBHOOK_URL" -ForegroundColor White
Write-Host "=" * 50 -ForegroundColor DarkGray
Write-Host ""
Write-Host "🚀 Próximos passos:" -ForegroundColor Green
Write-Host "  1. Acesse $EVOLUTION_URL/instance/connect/$INSTANCE_NAME e escaneie o QR Code" -ForegroundColor White
Write-Host "  2. Acesse http://localhost:5678 e importe o workflow (n8n-workflow-chatbot.json)" -ForegroundColor White
Write-Host "  3. Ative o workflow no n8n" -ForegroundColor White
Write-Host "  4. Envie uma mensagem para o número conectado e teste! 🎉" -ForegroundColor White
