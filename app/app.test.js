const request = require('supertest');
const app = require('./app');

describe('Paper.Social API', () => {
  it('should return welcome message', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('message', 'Welcome to Paper.Social API');
  });

  it('should return health status', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('status', 'healthy');
  });

  it('should create a new post', async () => {
    const res = await request(app)
      .post('/posts')
      .send({
        title: 'Test Post',
        content: 'This is a test post'
      });
    expect(res.statusCode).toEqual(201);
    expect(res.body).toHaveProperty('title', 'Test Post');
    expect(res.body).toHaveProperty('content', 'This is a test post');
  });

  it('should return 400 for invalid post', async () => {
    const res = await request(app)
      .post('/posts')
      .send({
        title: 'Test Post'
      });
    expect(res.statusCode).toEqual(400);
    expect(res.body).toHaveProperty('error', 'Title and content are required');
  });
}); 