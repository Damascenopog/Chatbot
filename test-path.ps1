$urls = @(
    "http://localhost:5678/webhook/whatsapp-webhook",
    "http://localhost:5678/webhook/j6a6uBIqv9S8InNp/webhook%20whatsapp/whatsapp-webhook",
    "http://localhost:5678/webhook/j6a6uBIqv9S8InNp/whatsapp-webhook"
)

foreach ($u in $urls) {
    Write-Host "Testando: $u"
    try {
        $res = Invoke-RestMethod -Uri $u -Method Post -Body '{}' -ContentType "application/json"
        Write-Host "SUCESSO 200 em: $u" -ForegroundColor Green
        $res | ConvertTo-Json
    } catch {
        Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Yellow
        if ($_.ErrorDetails) {
            Write-Host $_.ErrorDetails.Message -ForegroundColor Gray
        }
    }
}
