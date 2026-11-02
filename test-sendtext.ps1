$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

$body = @{
    "number" = "5521985971300"
    "text"   = "🤖 Teste de comunicacao n8n + Evolution API funcionando com sucesso!"
} | ConvertTo-Json

Write-Host "Testando sendText..."
try {
    $res = Invoke-RestMethod -Uri "http://localhost:8080/message/sendText/chatbot-filmes" -Method Post -Headers $headers -Body $body
    Write-Host "sendText funcionou perfeitamente!" -ForegroundColor Green
    $res | ConvertTo-Json -Depth 4
} catch {
    Write-Host "Erro sendText:" -ForegroundColor Red
    $_.Exception.Message
    if ($_.ErrorDetails) {
        $_.ErrorDetails.Message
    }
}
