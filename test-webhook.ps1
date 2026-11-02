$testPayload = @{
    "event" = "messages.upsert"
    "instance" = "chatbot-filmes"
    "data" = @{
        "key" = @{
            "fromMe" = $false
            "remoteJid" = "5521985971300@s.whatsapp.net"
            "id" = "TEST_SIMULATION_001"
        }
        "pushName" = "Cliente Teste"
        "message" = @{
            "conversation" = "Oi, quero saber sobre filmes"
        }
        "messageType" = "conversation"
    }
} | ConvertTo-Json -Depth 6

Write-Host "Enviando payload de teste para n8n..."
try {
    $res = Invoke-RestMethod -Uri "http://localhost:5678/webhook/whatsapp-webhook" -Method Post -ContentType "application/json" -Body $testPayload
    Write-Host "Resposta do n8n:" -ForegroundColor Green
    $res | ConvertTo-Json
} catch {
    Write-Host "Erro:" -ForegroundColor Red
    $_.Exception.Message
    if ($_.ErrorDetails) {
        $_.ErrorDetails.Message
    }
}
