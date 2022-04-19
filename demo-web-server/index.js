const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  const message = process.env.RESPONSE_MESSAGE
    ? process.env.RESPONSE_MESSAGE
    : "Hello world";
  res.send(message);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
