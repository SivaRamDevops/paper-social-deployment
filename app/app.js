const express = require('express');
const { Pool } = require('pg');
const winston = require('winston');

// Configure logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

const app = express();
const port = process.env.PORT || 3000;

// Database configuration
const pool = new Pool({
  user: process.env.POSTGRES_USER || 'paper_social',
  host: process.env.POSTGRES_HOST || 'db',
  database: process.env.POSTGRES_DB || 'paper_social',
  password: process.env.POSTGRES_PASSWORD || 'paper_social_password',
  port: process.env.POSTGRES_PORT || 5432,
});

// Initialize database
async function initializeDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS posts (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    logger.info('Database initialized successfully');
  } catch (error) {
    logger.error('Error initializing database:', error);
  }
}

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Paper.Social API' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.get('/posts', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM posts ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (error) {
    logger.error('Error fetching posts:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/posts', async (req, res) => {
  const { title, content } = req.body;
  if (!title || !content) {
    return res.status(400).json({ error: 'Title and content are required' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO posts (title, content) VALUES ($1, $2) RETURNING *',
      [title, content]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    logger.error('Error creating post:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start server
async function startServer() {
  await initializeDatabase();
  app.listen(port, () => {
    logger.info(`Server running on port ${port}`);
  });
}

startServer(); 