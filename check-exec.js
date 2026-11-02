const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT id, status, mode, startedAt, stoppedAt FROM execution_entity ORDER BY id DESC LIMIT 5", [], (err, rows) => {
    if (err) return console.error(err);
    console.log("Executions:", rows);
});
