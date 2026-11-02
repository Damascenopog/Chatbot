const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT name FROM sqlite_master WHERE type='table'", [], (err, rows) => {
    if (err) return console.error(err);
    console.log("Tables:", rows.map(r => r.name));
    
    // Inspecionar workflow_published_version se existir
    const tables = rows.map(r => r.name);
    const pubTable = tables.find(t => t.includes('publish') || t.includes('history') || t.includes('version'));
    console.log("Found version table:", pubTable);
});
