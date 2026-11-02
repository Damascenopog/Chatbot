$headers = @{
    "Authorization" = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwNjA3ZWY1MC1lMDNkLTRjNWYtODE2NS0xNDgxZjRjNmY1YTUiLCJpc3MiOiJuOG4iLCJqdGkiOiJjZmU0YmIyNC0yM2NlLTQ4NzUtYmU5NS1iNzkyNzUwYTJkYmQiLCJpYXQiOjE3OTM2NDk4OTQsImF1ZCI6Im1jcC1zZXJ2ZXItYXBpIn0.FDoEuroNINDWHNg897OyX1WXDx_ZqnBaaYVlB6UAHW8"
}

try {
    $res = Invoke-RestMethod -Uri "http://localhost:5678/api/v1/workflows" -Method Get -Headers $headers
    Write-Host "Sucesso /api/v1/workflows:" -ForegroundColor Green
    $res.data | ForEach-Object { Write-Host "ID: $($_.id) | Name: $($_.name) | Active: $($_.active)" }
} catch {
    Write-Host "Erro /api/v1:" $_.Exception.Message
    if ($_.ErrorDetails) { Write-Host $_.ErrorDetails.Message }
}
