$wf = Get-Content "c:\Users\arfda\Documents\Code\Projetos\Chatbot\n8n-workflow-chatbot.json" -Raw | ConvertFrom-Json

# Atualizar via MCP ou REST
Write-Host "Workflow pronto para ser importado/atualizado no n8n."
Write-Host "Total de nós:" $wf.nodes.Count
