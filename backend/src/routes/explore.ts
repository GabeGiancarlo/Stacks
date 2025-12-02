import { Router, Response } from 'express';
import { AppDataSource } from '../data-source';
import { Book } from '../entities/Book';
import { authenticateToken, AuthRequest } from '../middleware/auth';

const router = Router();
router.use(authenticateToken);

// GET /api/explore/recommendations - Get sample/recommended books
router.get('/recommendations', async (req: AuthRequest, res: Response) => {
  try {
    const bookRepository = AppDataSource.getRepository(Book);

    // Get random sample of books (limit 15)
    const books = await bookRepository
      .createQueryBuilder('book')
      .orderBy('RAND()')
      .limit(15)
      .getMany();

    const bookData = books.map((book) => ({
      id: book.id,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      description: book.description,
      publishedYear: book.publishedYear,
    }));

    res.json(bookData);
  } catch (error) {
    console.error('Get recommendations error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;

