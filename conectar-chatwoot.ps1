# ==============================================================================
# Script de Conexão da Evolution API com o Chatwoot
# ==============================================================================

param (
    [string]$ChatwootToken,
    [string]$AccountId = "1",
    [string]$InstanceName = "chatbot-filmes"
)

# Carregar variáveis do .env se existirem
if (Test-Path .env) {
    Get-Content .env | Where-Object { $_ -match '^[^#].*=' } | ForEach-Object {
        $parts = $_ -split '=', 2
        $varName = $parts[0].Trim()
        $varVal = $parts[1].Trim()
        if (-not [System.Environment]::GetEnvironmentVariable($varName)) {
            [System.Environment]::SetEnvironmentVariable($varName, $varVal)
        }
    }
}

$EVOLUTION_URL = "http://localhost:8080"
$API_KEY = $env:EVOLUTION_API_KEY
# URL interna do Chatwoot no Docker bridge network
$CHATWOOT_INTERNAL_URL = "http://chatwoot-web:3000"

if (-not $API_KEY) {
    Write-Host "❌ Variável EVOLUTION_API_KEY não definida no .env ou no terminal." -ForegroundColor Red
    exit 1
}

if (-not $ChatwootToken) {
    Write-Host "`n🔑 Insira o Token de Acesso do seu usuário no Chatwoot." -ForegroundColor Yellow
    Write-Host "   (Você encontra em: Chatwoot > Canto inferior esquerdo > Configurações do Perfil > Token de Acesso)" -ForegroundColor Gray
    $ChatwootToken = Read-Host "Token do Chatwoot"
}

if (-not $ChatwootToken) {
    Write-Host "❌ Token não informado. Operação cancelada." -ForegroundColor Red
    exit 1
}

$headers = @{
    "apikey"       = $API_KEY
    "Content-Type" = "application/json"
}

$body = @{
    enabled                  = $true
    accountId                = [string]$AccountId
    token                    = $ChatwootToken
    url                      = $CHATWOOT_INTERNAL_URL
    nameInbox                = "WhatsApp Atendimento"
    signMsg                  = $true
    reopenConversation       = $true
    conversationPending      = $false
    importContacts           = $true
    importMessages           = $true
    daysLimitImportMessages  = 3
    autoCreate               = $true
} | ConvertTo-Json

Write-Host "`n🔗 Vinculando a instância '$InstanceName' ao Chatwoot..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "$EVOLUTION_URL/chatwoot/set/$InstanceName" -Method Post -Headers $headers -Body $body
    Write-Host "✅ Instância conectada com sucesso ao Chatwoot!" -ForegroundColor Green
    Write-Host ""
    Write-Host ($response | ConvertTo-Json -Depth 4)
    Write-Host ""
    Write-Host "🎉 Tudo pronto! Acesse http://localhost:3000 para atender seus clientes." -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao vincular ao Chatwoot: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "Detalhe: $($reader.ReadToEnd())" -ForegroundColor DarkRed
    }
}
