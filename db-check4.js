const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT nodes, connections FROM workflow_history WHERE versionId = '1a18c304-8549-41cb-b35d-abeebc7fe4c2'", [], (err, rows) => {
    if (err) return console.error(err);
    if (rows && rows.length > 0) {
        const nodes = JSON.parse(rows[0].nodes);
        console.log("Nodes count:", nodes.length);
        console.log("Nodes:", nodes.map(n => ({ id: n.id, name: n.name, type: n.type })));
    }
});
