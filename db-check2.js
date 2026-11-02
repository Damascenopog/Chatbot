const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT * FROM workflow_published_version", [], (err, rows) => {
    console.log("workflow_published_version count:", rows ? rows.length : 0);
    if (rows && rows.length > 0) console.log(rows);
});

db.all("SELECT * FROM workflow_publication_trigger_status", [], (err, rows) => {
    console.log("workflow_publication_trigger_status count:", rows ? rows.length : 0);
    if (rows && rows.length > 0) console.log(rows);
});
