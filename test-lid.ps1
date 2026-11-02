$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

Write-Host "--- Teste 1: Enviando com o LID completo (96220236222467@lid) ---"
$bodyLid = @{
    "number" = "96220236222467@lid"
    "text"   = "Teste via LID"
} | ConvertTo-Json

try {
    $res1 = Invoke-RestMethod -Uri "http://localhost:8080/message/sendText/chatbot-filmes" -Method Post -Headers $headers -Body $bodyLid
    Write-Host "Sucesso via LID!" -ForegroundColor Green
    $res1 | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erro via LID:" $_.Exception.Message -ForegroundColor Red
    if ($_.ErrorDetails) { $_.ErrorDetails.Message }
}

Write-Host "`n--- Teste 2: Enviando com numero real (5521998198984) ---"
$bodyReal = @{
    "number" = "5521998198984"
    "text"   = "Teste via Numero Real"
} | ConvertTo-Json

try {
    $res2 = Invoke-RestMethod -Uri "http://localhost:8080/message/sendText/chatbot-filmes" -Method Post -Headers $headers -Body $bodyReal
    Write-Host "Sucesso via Numero Real!" -ForegroundColor Green
    $res2 | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erro via Numero Real:" $_.Exception.Message -ForegroundColor Red
    if ($_.ErrorDetails) { $_.ErrorDetails.Message }
}
