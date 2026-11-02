const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT nodes FROM workflow_entity WHERE id = 'j6a6uBIqv9S8InNp'", [], (err, rows) => {
    if (err) return console.error(err);
    const nodes = JSON.parse(rows[0].nodes);
    const webhook = nodes.find(n => n.type.includes('webhook'));
    console.log("Webhook node params:", JSON.stringify(webhook, null, 2));
});
