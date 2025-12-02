import { Router, Response } from 'express';
import { AppDataSource } from '../data-source';
import { User } from '../entities/User';
import { UserBook } from '../entities/UserBook';
import { Review } from '../entities/Review';
import { UserBadge } from '../entities/UserBadge';
import { authenticateToken, AuthRequest } from '../middleware/auth';

const router = Router();
router.use(authenticateToken);

// GET /api/users/me - Get current user profile with stats
router.get('/me', async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.userId!;

    const userRepository = AppDataSource.getRepository(User);
    const userBookRepository = AppDataSource.getRepository(UserBook);
    const reviewRepository = AppDataSource.getRepository(Review);

    const user = await userRepository.findOne({ where: { id: userId } });
    if (!user) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    // Calculate stats
    const totalBooks = await userBookRepository.count({ where: { userId } });
    const booksRead = await userBookRepository.count({
      where: { userId, status: 'read' as any },
    });
    const reviewsWritten = await reviewRepository.count({ where: { userId } });

    // Calculate reading streak (simplified - days since last book added)
    const lastBook = await userBookRepository.findOne({
      where: { userId },
      order: { addedAt: 'DESC' },
    });
    const readingStreak = lastBook
      ? Math.floor((Date.now() - lastBook.addedAt.getTime()) / (1000 * 60 * 60 * 24))
      : 0;

    res.json({
      id: user.id,
      email: user.email,
      username: user.username,
      createdAt: user.createdAt,
      stats: {
        totalBooks,
        booksRead,
        reviewsWritten,
        readingStreak,
      },
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/users/me/badges - Get user's earned badges
router.get('/me/badges', async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.userId!;

    const userBadgeRepository = AppDataSource.getRepository(UserBadge);

    const userBadges = await userBadgeRepository.find({
      where: { userId },
      relations: ['badge'],
      order: { earnedAt: 'DESC' },
    });

    const badgeData = userBadges.map((ub) => ({
      id: ub.badge.id,
      name: ub.badge.name,
      tier: ub.badge.tier,
      iconUrl: ub.badge.iconUrl,
      criteria: ub.badge.criteria,
      earnedAt: ub.earnedAt,
    }));

    res.json(badgeData);
  } catch (error) {
    console.error('Get badges error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;

