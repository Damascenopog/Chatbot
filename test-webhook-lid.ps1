$testPayload = @{
    "event" = "messages.upsert"
    "instance" = "chatbot-filmes"
    "data" = @{
        "key" = @{
            "fromMe" = $false
            "remoteJid" = "96220236222467@lid"
            "id" = "TEST_JULIO_001"
        }
        "pushName" = "Julio"
        "message" = @{
            "conversation" = "oi"
        }
        "messageType" = "conversation"
    }
} | ConvertTo-Json -Depth 6

Write-Host "Enviando teste com LID para n8n..."
try {
    $res = Invoke-RestMethod -Uri "http://localhost:5678/webhook/whatsapp-webhook" -Method Post -ContentType "application/json" -Body $testPayload
    Write-Host "Resposta n8n:" -ForegroundColor Green
    $res | ConvertTo-Json
} catch {
    Write-Host "Erro:" -ForegroundColor Red
    $_.Exception.Message
    if ($_.ErrorDetails) {
        $_.ErrorDetails.Message
    }
}
