$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

$webhookBody = @{
    "webhook" = @{
        "enabled"           = $true
        "url"               = "http://n8n:5678/webhook/whatsapp-webhook"
        "webhookByEvents"   = $false
        "events"            = @("MESSAGES_UPSERT")
    }
} | ConvertTo-Json -Depth 5

Write-Host "Configurando webhook v2..."
try {
    $resWebhook = Invoke-RestMethod -Uri "http://localhost:8080/webhook/set/chatbot-filmes" -Method Post -Headers $headers -Body $webhookBody
    Write-Host "Webhook configurado com sucesso!" -ForegroundColor Green
    $resWebhook | ConvertTo-Json -Depth 4
} catch {
    Write-Host "Erro ao configurar webhook:" -ForegroundColor Yellow
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message
    }
}
