// app.test.js
const request = require('supertest');
const app = require('./app');

describe('Test the root path', () => {
    test('It should respond to the GET method', async () => {
        const response = await request(app).get('/');
        expect(response.statusCode).toBe(200);
        expect(response.text).toBe('Hello, World!');
    });
});

describe('Test the /name/:name path', () => {
    test('It should respond with a personalized greeting', async () => {
        const name = 'Alice';
        const response = await request(app).get(`/name/${name}`);
        expect(response.statusCode).toBe(200);
        expect(response.text).toBe(`Hello, ${name}!`);
    });
});

describe('Test the /add/:a/:b path', () => {
  test('It should return the sum of two positive numbers', async () => {
    const response = await request(app).get('/add/5/10');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('15');
  });

  test('It should work with negative numbers', async () => {
    const response = await request(app).get('/add/-5/2');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('-3');
  });

  test('It should return 400 for invalid inputs (strings)', async () => {
    const response = await request(app).get('/add/hello/5');
    expect(response.statusCode).toBe(400);
    expect(response.text).toBe('Invalid numbers provided');
  });
});