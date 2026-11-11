# ==============================================================================
# Script de Inicialização e Verificação do Chatwoot
# ==============================================================================

Write-Host "`n🚀 Subindo containers do Chatwoot (Postgres Vector, Web e Worker)..." -ForegroundColor Cyan

docker compose up -d chatwoot-postgres chatwoot-web chatwoot-worker

Write-Host "`n⏳ Aguardando os serviços inicializarem..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "`n📋 Status dos containers:" -ForegroundColor Cyan
docker compose ps chatwoot-postgres chatwoot-web chatwoot-worker

Write-Host "`n" -NoNewline
Write-Host "=" * 60 -ForegroundColor DarkGray
Write-Host "🎉 CHATWOOT INSTALADO COM SUCESSO!" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor DarkGray
Write-Host "  URL de Acesso:  http://localhost:3000" -ForegroundColor White
Write-Host "  Painel Admin:   http://localhost:3000/app/login" -ForegroundColor White
Write-Host "=" * 60 -ForegroundColor DarkGray
Write-Host "`n👉 Passos para Primeiro Acesso e Conexão:" -ForegroundColor Yellow
Write-Host "  1. Acesse http://localhost:3000 no navegador e crie sua conta de Administrador."
Write-Host "  2. No Chatwoot, clique na sua foto/nome no canto inferior esquerdo > 'Configurações do Perfil'."
Write-Host "  3. Role até o final da página e copie seu 'Token de Acesso'."
Write-Host "  4. Execute no PowerShell:" -ForegroundColor White
Write-Host "     .\conectar-chatwoot.ps1 -ChatwootToken 'SEU_TOKEN_AQUI'" -ForegroundColor Cyan
Write-Host ""
