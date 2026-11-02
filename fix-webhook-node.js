const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT nodes, connections FROM workflow_entity WHERE id = 'j6a6uBIqv9S8InNp'", [], (err, rows) => {
    if (err) return console.error(err);
    const nodes = JSON.parse(rows[0].nodes);
    
    // Atualizar o nó webhook para typeVersion 2 e adicionar webhookId
    const webhook = nodes.find(n => n.type.includes('webhook'));
    if (webhook) {
        webhook.typeVersion = 2;
        webhook.webhookId = "whatsapp-webhook";
        webhook.parameters.path = "whatsapp-webhook";
    }
    
    const updatedNodesJson = JSON.stringify(nodes);
    
    db.run("UPDATE workflow_entity SET nodes = ? WHERE id = 'j6a6uBIqv9S8InNp'", [updatedNodesJson], function(uErr) {
        if (uErr) return console.error(uErr);
        console.log("Updated workflow_entity nodes. Changed:", this.changes);
        
        // Também atualizar na última versão de workflow_history
        db.run("UPDATE workflow_history SET nodes = ? WHERE workflowId = 'j6a6uBIqv9S8InNp' AND versionId = '1a18c304-8549-41cb-b35d-abeebc7fe4c2'", [updatedNodesJson], function(hErr) {
            console.log("Updated workflow_history nodes. Changed:", this.changes);
        });
    });
});
