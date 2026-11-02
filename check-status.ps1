$headers = @{
    "apikey" = $env:EVOLUTION_API_KEY
}

$state = Invoke-RestMethod -Uri "http://localhost:8080/instance/connectionState/chatbot-filmes" -Headers $headers
Write-Host ($state | ConvertTo-Json -Depth 3)
