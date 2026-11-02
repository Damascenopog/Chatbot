$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

$body = @{
    "groupsIgnore"    = $true
    "rejectCall"      = $true
    "alwaysOnline"    = $true
    "readMessages"    = $true
    "readStatus"      = $false
    "syncFullHistory" = $false
} | ConvertTo-Json

Write-Host "Configurando settings..."
try {
    $res = Invoke-RestMethod -Uri "http://localhost:8080/settings/set/chatbot-filmes" -Method Post -Headers $headers -Body $body
    Write-Host "Settings atualizadas com sucesso!" -ForegroundColor Green
    $res | ConvertTo-Json -Depth 3
} catch {
    Write-Host "Erro:" $_.Exception.Message
    if ($_.ErrorDetails) {
        $_.ErrorDetails.Message
    }
}
