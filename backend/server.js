const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/health", (req, res) => {
  res.json({ status: "healthy" });
});

app.get("/version", (req, res) => {
  res.json({
    app: "eks-production-platform-api",
    version: "1.0.0"
  });
});

app.get("/api/status", (req, res) => {
  res.json({
    message: "Backend API is running"
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`API running on port ${PORT}`);
});
