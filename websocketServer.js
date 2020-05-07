const WebSocket = require("ws");

// start the server and specify the port number
const port = 8080;
const wss = new WebSocket.Server({ port: port });

console.log(`[WebSocket] Starting WebSocket server on localhost:${port}`);

wss.on("connection", (ws, request) => {
  const clientIp = request.connection.remoteAddress;
  console.log(`[WebSocket] Client with IP ${clientIp} has connected`);

  // Broadcast aka send messages to all connected clients
  ws.on("message", (message) => {
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
    console.log(`[WebSocket] Message ${message} was received`);
  });
});
