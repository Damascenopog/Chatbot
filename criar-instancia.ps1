$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

$createBody = @{
    "instanceName" = "chatbot-filmes"
    "integration"  = "WHATSAPP-BAILEYS"
    "qrcode"       = $true
} | ConvertTo-Json

Write-Host "Criando instancia..."
try {
    $res = Invoke-RestMethod -Uri "http://localhost:8080/instance/create" -Method Post -Headers $headers -Body $createBody
    Write-Host "Instancia criada com sucesso!" -ForegroundColor Green
    $res | ConvertTo-Json -Depth 4
} catch {
    Write-Host "Erro ou detalhe:" -ForegroundColor Yellow
    $_.Exception.Response | Format-List
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message
    }
}

$webhookBody = @{
    "url"               = "http://n8n:5678/webhook/whatsapp-webhook"
    "webhook_by_events" = $false
    "events"            = @("MESSAGES_UPSERT")
} | ConvertTo-Json

Write-Host "`nConfigurando webhook..."
try {
    $resWebhook = Invoke-RestMethod -Uri "http://localhost:8080/webhook/set/chatbot-filmes" -Method Post -Headers $headers -Body $webhookBody
    Write-Host "Webhook configurado com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "Erro ao configurar webhook:" -ForegroundColor Yellow
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message
    }
}
