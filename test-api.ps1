# Testar endpoints do n8n
$cookieJar = New-Object System.Net.CookieContainer

# Vamos buscar a lista de workflows via REST
try {
    $res = Invoke-RestMethod -Uri "http://localhost:5678/rest/workflows" -Method Get
    Write-Host "Workflows encontrados via REST:" -ForegroundColor Green
    $res.data | ForEach-Object { Write-Host "ID: $($_.id) | Name: $($_.name) | Active: $($_.active)" }
} catch {
    Write-Host "Erro /rest/workflows:" $_.Exception.Message
    if ($_.ErrorDetails) { Write-Host $_.ErrorDetails.Message }
}
