# Diagnostico e reconexao
$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

# 1. Verificar estado atual
Write-Host "=== Estado atual da instancia ===" -ForegroundColor Cyan
try {
    $state = Invoke-RestMethod -Uri "http://localhost:8080/instance/connectionState/chatbot-filmes" -Headers $headers
    Write-Host ($state | ConvertTo-Json -Depth 3)
} catch {
    Write-Host "Erro: $($_.ErrorDetails.Message)" -ForegroundColor Red
}

# 2. Fazer logout para limpar sessao corrompida
Write-Host "`n=== Fazendo logout da instancia ===" -ForegroundColor Yellow
try {
    $logout = Invoke-RestMethod -Uri "http://localhost:8080/instance/logout/chatbot-filmes" -Method Delete -Headers $headers
    Write-Host "Logout OK" -ForegroundColor Green
    Write-Host ($logout | ConvertTo-Json -Depth 3)
} catch {
    Write-Host "Logout erro (normal se nao estava conectado): $($_.ErrorDetails.Message)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# 3. Tentar conectar com pairing code
Write-Host "`n=== Tentando gerar pairing code ===" -ForegroundColor Cyan
try {
    $connect = Invoke-RestMethod -Uri "http://localhost:8080/instance/connect/chatbot-filmes?number=5521985971300" -Headers $headers
    Write-Host "Resposta:" -ForegroundColor Green
    
    # Mostrar pairing code se existir
    if ($connect.pairingCode) {
        Write-Host "`n========================================" -ForegroundColor Green
        Write-Host "  CODIGO DE PAREAMENTO: $($connect.pairingCode)" -ForegroundColor White -BackgroundColor DarkGreen
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "`nNo WhatsApp do celular:" -ForegroundColor Yellow
        Write-Host "  1. Aparelhos conectados > Conectar um aparelho" -ForegroundColor White
        Write-Host "  2. Toque em 'Conectar com numero de telefone'" -ForegroundColor White
        Write-Host "  3. Digite o codigo: $($connect.pairingCode)" -ForegroundColor White
    } else {
        Write-Host ($connect | ConvertTo-Json -Depth 4)
    }
} catch {
    Write-Host "Erro ao conectar: $($_.ErrorDetails.Message)" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
