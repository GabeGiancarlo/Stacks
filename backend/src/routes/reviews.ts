import { Router, Response } from 'express';
import { AppDataSource } from '../data-source';
import { Review } from '../entities/Review';
import { UserBook } from '../entities/UserBook';
import { authenticateToken, AuthRequest } from '../middleware/auth';

const router = Router();
router.use(authenticateToken);

// POST /api/books/:bookId/reviews - Create review
router.post('/books/:bookId/reviews', async (req: AuthRequest, res: Response) => {
  try {
    const bookId = parseInt(req.params.bookId);
    const userId = req.userId!;
    const { rating, reviewText } = req.body;

    if (!rating || rating < 1 || rating > 5) {
      res.status(400).json({ error: 'Rating must be between 1 and 5' });
      return;
    }

    // Check if user has the book in their library
    const userBookRepository = AppDataSource.getRepository(UserBook);
    const userBook = await userBookRepository.findOne({
      where: { userId, bookId },
    });

    if (!userBook) {
      res.status(403).json({ error: 'Book not in your library' });
      return;
    }

    // Check if review already exists
    const reviewRepository = AppDataSource.getRepository(Review);
    const existingReview = await reviewRepository.findOne({
      where: { userId, bookId },
    });

    if (existingReview) {
      res.status(409).json({ error: 'Review already exists for this book' });
      return;
    }

    const review = reviewRepository.create({
      userId,
      bookId,
      rating: parseInt(rating),
      reviewText: reviewText || undefined,
    });

    const savedReview = await reviewRepository.save(review);

    res.status(201).json({
      id: savedReview.id,
      userId: savedReview.userId,
      bookId: savedReview.bookId,
      rating: savedReview.rating,
      reviewText: savedReview.reviewText,
      createdAt: savedReview.createdAt,
      updatedAt: savedReview.updatedAt,
    });
  } catch (error) {
    console.error('Create review error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// PUT /api/reviews/:id - Update review
router.put('/:id', async (req: AuthRequest, res: Response) => {
  try {
    const reviewId = parseInt(req.params.id);
    const userId = req.userId!;
    const { rating, reviewText } = req.body;

    const reviewRepository = AppDataSource.getRepository(Review);
    const review = await reviewRepository.findOne({
      where: { id: reviewId },
    });

    if (!review) {
      res.status(404).json({ error: 'Review not found' });
      return;
    }

    if (review.userId !== userId) {
      res.status(403).json({ error: 'Not authorized to update this review' });
      return;
    }

    if (rating !== undefined) {
      if (rating < 1 || rating > 5) {
        res.status(400).json({ error: 'Rating must be between 1 and 5' });
        return;
      }
      review.rating = parseInt(rating);
    }

    if (reviewText !== undefined) {
      review.reviewText = reviewText || undefined;
    }

    await reviewRepository.save(review);

    res.json({
      id: review.id,
      userId: review.userId,
      bookId: review.bookId,
      rating: review.rating,
      reviewText: review.reviewText,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
    });
  } catch (error) {
    console.error('Update review error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE /api/reviews/:id - Delete review
router.delete('/:id', async (req: AuthRequest, res: Response) => {
  try {
    const reviewId = parseInt(req.params.id);
    const userId = req.userId!;

    const reviewRepository = AppDataSource.getRepository(Review);
    const review = await reviewRepository.findOne({
      where: { id: reviewId },
    });

    if (!review) {
      res.status(404).json({ error: 'Review not found' });
      return;
    }

    if (review.userId !== userId) {
      res.status(403).json({ error: 'Not authorized to delete this review' });
      return;
    }

    await reviewRepository.remove(review);
    res.json({ message: 'Review deleted successfully' });
  } catch (error) {
    console.error('Delete review error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;

