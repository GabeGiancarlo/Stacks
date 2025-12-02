import { Router, Response } from 'express';
import { AppDataSource } from '../data-source';
import { Book } from '../entities/Book';
import { UserBook, BookStatus } from '../entities/UserBook';
import { Review } from '../entities/Review';
import { authenticateToken, AuthRequest } from '../middleware/auth';
import multer from 'multer';
import path from 'path';
import fs from 'fs';

const router = Router();
router.use(authenticateToken);

// Configure multer for file uploads
const upload = multer({
  dest: 'uploads/',
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error('Only image files are allowed'));
  },
});

// GET /api/books - Get user's library
router.get('/', async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.userId!;
    const userBookRepository = AppDataSource.getRepository(UserBook);
    const bookRepository = AppDataSource.getRepository(Book);

    const userBooks = await userBookRepository.find({
      where: { userId },
      relations: ['book'],
      order: { addedAt: 'DESC' },
    });

    const books = userBooks.map((ub) => ({
      id: ub.book.id,
      isbn: ub.book.isbn,
      title: ub.book.title,
      author: ub.book.author,
      coverUrl: ub.book.coverUrl,
      description: ub.book.description,
      publishedYear: ub.book.publishedYear,
      status: ub.status,
      addedAt: ub.addedAt,
    }));

    res.json(books);
  } catch (error) {
    console.error('Get books error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/books - Add book to library
router.post('/', upload.single('cover'), async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.userId!;
    const { isbn, title, author, description, publishedYear, status } = req.body;

    if (!title || !author) {
      res.status(400).json({ error: 'Title and author are required' });
      return;
    }

    const bookRepository = AppDataSource.getRepository(Book);
    const userBookRepository = AppDataSource.getRepository(UserBook);

    // Check if book with ISBN already exists
    let book: Book;
    if (isbn) {
      const existingBook = await bookRepository.findOne({ where: { isbn } });
      if (existingBook) {
        book = existingBook;
      } else {
        book = bookRepository.create({
          isbn,
          title,
          author,
          description,
          publishedYear: publishedYear ? parseInt(publishedYear) : undefined,
        });
        await bookRepository.save(book);
      }
    } else {
      book = bookRepository.create({
        title,
        author,
        description,
        publishedYear: publishedYear ? parseInt(publishedYear) : undefined,
      });
      await bookRepository.save(book);
    }

    // Handle cover image upload
    if (req.file) {
      const coverUrl = `/uploads/${req.file.filename}`;
      book.coverUrl = coverUrl;
      await bookRepository.save(book);
    }

    // Check if user already has this book
    const existingUserBook = await userBookRepository.findOne({
      where: { userId, bookId: book.id },
    });

    if (existingUserBook) {
      res.status(409).json({ error: 'Book already in library' });
      return;
    }

    // Add book to user's library
    const userBook = userBookRepository.create({
      userId,
      bookId: book.id,
      status: (status as BookStatus) || BookStatus.WANT_TO_READ,
    });
    await userBookRepository.save(userBook);

    res.status(201).json({
      id: book.id,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      description: book.description,
      publishedYear: book.publishedYear,
      status: userBook.status,
      addedAt: userBook.addedAt,
    });
  } catch (error) {
    console.error('Add book error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/books/:id - Get book details with reviews
router.get('/:id', async (req: AuthRequest, res: Response) => {
  try {
    const bookId = parseInt(req.params.id);
    const userId = req.userId!;

    const bookRepository = AppDataSource.getRepository(Book);
    const userBookRepository = AppDataSource.getRepository(UserBook);
    const reviewRepository = AppDataSource.getRepository(Review);

    const book = await bookRepository.findOne({ where: { id: bookId } });
    if (!book) {
      res.status(404).json({ error: 'Book not found' });
      return;
    }

    const userBook = await userBookRepository.findOne({
      where: { userId, bookId },
    });

    const reviews = await reviewRepository.find({
      where: { bookId },
      relations: ['user'],
      order: { createdAt: 'DESC' },
    });

    const reviewData = reviews.map((r) => ({
      id: r.id,
      userId: r.userId,
      username: r.user.username,
      rating: r.rating,
      reviewText: r.reviewText,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
    }));

    res.json({
      id: book.id,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      description: book.description,
      publishedYear: book.publishedYear,
      status: userBook?.status,
      reviews: reviewData,
    });
  } catch (error) {
    console.error('Get book error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// PUT /api/books/:id - Update book
router.put('/:id', upload.single('cover'), async (req: AuthRequest, res: Response) => {
  try {
    const bookId = parseInt(req.params.id);
    const userId = req.userId!;
    const { title, author, description, publishedYear, status } = req.body;

    const bookRepository = AppDataSource.getRepository(Book);
    const userBookRepository = AppDataSource.getRepository(UserBook);

    const book = await bookRepository.findOne({ where: { id: bookId } });
    if (!book) {
      res.status(404).json({ error: 'Book not found' });
      return;
    }

    const userBook = await userBookRepository.findOne({
      where: { userId, bookId },
    });
    if (!userBook) {
      res.status(403).json({ error: 'Book not in your library' });
      return;
    }

    // Update book fields
    if (title) book.title = title;
    if (author) book.author = author;
    if (description !== undefined) book.description = description;
    if (publishedYear) book.publishedYear = parseInt(publishedYear);

    // Handle cover image upload
    if (req.file) {
      // Delete old cover if exists
      if (book.coverUrl && book.coverUrl.startsWith('/uploads/')) {
        const oldPath = path.join(process.cwd(), book.coverUrl);
        if (fs.existsSync(oldPath)) {
          fs.unlinkSync(oldPath);
        }
      }
      book.coverUrl = `/uploads/${req.file.filename}`;
    }

    await bookRepository.save(book);

    // Update user book status if provided
    if (status) {
      userBook.status = status as BookStatus;
      await userBookRepository.save(userBook);
    }

    res.json({
      id: book.id,
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      description: book.description,
      publishedYear: book.publishedYear,
      status: userBook.status,
    });
  } catch (error) {
    console.error('Update book error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE /api/books/:id - Remove book from library
router.delete('/:id', async (req: AuthRequest, res: Response) => {
  try {
    const bookId = parseInt(req.params.id);
    const userId = req.userId!;

    const userBookRepository = AppDataSource.getRepository(UserBook);
    const userBook = await userBookRepository.findOne({
      where: { userId, bookId },
    });

    if (!userBook) {
      res.status(404).json({ error: 'Book not found in your library' });
      return;
    }

    await userBookRepository.remove(userBook);
    res.json({ message: 'Book removed from library' });
  } catch (error) {
    console.error('Delete book error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;

