const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.run("UPDATE webhook_entity SET webhookPath = 'whatsapp-webhook' WHERE workflowId = 'j6a6uBIqv9S8InNp'", function(err) {
    if (err) return console.error(err);
    console.log("Updated webhookPath to 'whatsapp-webhook'. Changed rows:", this.changes);
    
    db.all("SELECT * FROM webhook_entity", [], (err, rows) => {
        console.log(rows);
    });
});
