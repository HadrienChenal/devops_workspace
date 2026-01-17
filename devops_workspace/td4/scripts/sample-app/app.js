// app.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.get('/name/:name', (req, res) => {
  const name = req.params.name;
  res.send(`Hello, ${name}!`);
});

app.get('/add/:a/:b', (req, res) => {
  const a = parseFloat(req.params.a);
  const b = parseFloat(req.params.b);

  if (isNaN(a) || isNaN(b)) {
    return res.status(400).send('Invalid numbers provided');
  }
  const sum = a + b;
  res.send(sum.toString());
});

module.exports = app;