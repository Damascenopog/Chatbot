const sqlite3 = require('/usr/local/lib/node_modules/n8n/node_modules/.pnpm/sqlite3@5.1.7_bluebird@3.7.2_supports-color@8.1.1/node_modules/sqlite3');
const zlib = require('zlib');
const db = new sqlite3.Database('/home/node/.n8n/database.sqlite');

db.all("SELECT data FROM execution_data WHERE executionId = 17", [], (err, rows) => {
    if (err) return console.error(err);
    if (rows && rows.length > 0) {
        let raw = rows[0].data;
        try {
            raw = zlib.gunzipSync(raw).toString();
        } catch(e) {}
        console.log("Raw preview:", typeof raw, raw ? raw.substring(0, 300) : "empty");
    }
});
