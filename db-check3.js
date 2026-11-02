const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT id, name, versionId, activeVersionId FROM workflow_entity WHERE id = 'j6a6uBIqv9S8InNp'", [], (err, rows) => {
    console.log("workflow_entity:", rows);
});

db.all("SELECT * FROM workflow_history WHERE workflowId = 'j6a6uBIqv9S8InNp'", [], (err, rows) => {
    console.log("workflow_history count:", rows ? rows.length : 0);
    if (rows && rows.length > 0) {
        console.log("history versionIds:", rows.map(r => r.versionId));
    }
});
