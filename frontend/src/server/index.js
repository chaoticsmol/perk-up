import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
var __filename = fileURLToPath(import.meta.url);
var __dirname = path.dirname(__filename);
var app = express();
var PORT = process.env.PORT || 3001;
// API routes can be added here
app.get('/api/health', function (req, res) {
    res.json({ status: 'healthy' });
});
// Serve static files from the React app in production
if (process.env.NODE_ENV === 'production') {
    app.use(express.static(path.resolve(__dirname, '../../dist')));
    // Handle React routing, return all requests to React app
    app.get('*', function (req, res) {
        res.sendFile(path.resolve(__dirname, '../../dist', 'index.html'));
    });
}
app.listen(PORT, function () {
    console.log("Server listening on port ".concat(PORT));
});
export default app;
