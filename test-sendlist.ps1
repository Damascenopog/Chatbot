$headers = @{
    "apikey"       = $env:EVOLUTION_API_KEY
    "Content-Type" = "application/json"
}

$body = @{
    "number"      = "5521985971300"
    "title"       = "CineApp - Filmes"
    "description" = "Teste de menu interativo"
    "buttonText"  = "Ver Opcoes"
    "footerText"  = "CineApp 2026"
    "sections"    = @(
        @{
            "title" = "Opcoes"
            "rows"  = @(
                @{
                    "title"       = "Planos"
                    "description" = "Ver precos"
                    "rowId"       = "planos_precos"
                }
            )
        }
    )
} | ConvertTo-Json -Depth 5

Write-Host "Testando endpoint sendList..."
try {
    $res = Invoke-RestMethod -Uri "http://localhost:8080/message/sendList/chatbot-filmes" -Method Post -Headers $headers -Body $body
    Write-Host "Sucesso ao enviar sendList!" -ForegroundColor Green
    $res | ConvertTo-Json -Depth 4
} catch {
    Write-Host "Erro sendList:" -ForegroundColor Red
    $_.Exception.Message
    if ($_.ErrorDetails) {
        $_.ErrorDetails.Message
    }
}
