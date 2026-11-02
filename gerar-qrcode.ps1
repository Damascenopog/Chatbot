$headers = @{
    "apikey" = $env:EVOLUTION_API_KEY
}

try {
    $res = Invoke-RestMethod -Uri "http://localhost:8080/instance/connect/chatbot-filmes" -Headers $headers -Method Get
    Write-Host "Status da Instancia:" ($res | ConvertTo-Json -Depth 2)
    
    $qrBase64 = $res.base64
    if (-not $qrBase64 -and $res.qrcode) {
        $qrBase64 = $res.qrcode.base64
    }

    if ($qrBase64) {
        $html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Escanear QR Code - WhatsApp Chatbot</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 100vh; margin: 0; background-color: #0f172a; color: #fff; }
        .card { background: #1e293b; padding: 2rem; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); text-align: center; max-width: 400px; }
        img { width: 280px; height: 280px; border-radius: 8px; margin: 1.5rem 0; background: white; padding: 10px; }
        h1 { margin-top: 0; font-size: 1.5rem; color: #38bdf8; }
        p { color: #94a3b8; font-size: 0.95rem; line-height: 1.4; }
        .btn { display: inline-block; padding: 10px 20px; background: #22c55e; color: white; border-radius: 6px; text-decoration: none; font-weight: bold; cursor: pointer; border: none; }
        .btn:hover { background: #16a34a; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Conectar WhatsApp</h1>
        <p>1. Abra o WhatsApp no celular<br>2. Vá em <b>Aparelhos conectados</b><br>3. Toque em <b>Conectar um aparelho</b></p>
        <img src="$qrBase64" alt="QR Code WhatsApp" />
        <br>
        <button class="btn" onclick="location.reload()">Atualizar QR Code</button>
    </div>
</body>
</html>
"@
        $html | Out-File -FilePath "c:\Users\arfda\Documents\Code\Projetos\Chatbot\qrcode.html" -Encoding utf8
        Write-Host "Arquivo qrcode.html gerado com sucesso!" -ForegroundColor Green
        Start-Process "c:\Users\arfda\Documents\Code\Projetos\Chatbot\qrcode.html"
    } else {
        Write-Host "QR Code não encontrado na resposta ou já conectado." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Erro:" $_.Exception.Message -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message
    }
}
