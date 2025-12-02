import { Router, Request, Response } from 'express';
import { AppDataSource } from '../data-source';
import { User } from '../entities/User';
import {
  hashPassword,
  comparePassword,
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
} from '../utils/auth';
import rateLimit from 'express-rate-limit';

const router = Router();

// Rate limiting for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: 'Too many requests from this IP, please try again later.',
});

router.use(authLimiter);

interface SignupRequest {
  email: string;
  password: string;
  username: string;
}

interface LoginRequest {
  email: string;
  password: string;
}

interface RefreshRequest {
  refreshToken: string;
}

// POST /api/auth/signup
router.post('/signup', async (req: Request<{}, {}, SignupRequest>, res: Response) => {
  try {
    const { email, password, username } = req.body;

    if (!email || !password || !username) {
      res.status(400).json({ error: 'Email, password, and username are required' });
      return;
    }

    const userRepository = AppDataSource.getRepository(User);
    const existingUser = await userRepository.findOne({ where: { email } });

    if (existingUser) {
      res.status(409).json({ error: 'Email already registered' });
      return;
    }

    const passwordHash = await hashPassword(password);
    const user = userRepository.create({
      email,
      passwordHash,
      username,
    });

    const savedUser = await userRepository.save(user);

    const tokenPayload = { userId: savedUser.id, email: savedUser.email };
    const accessToken = generateAccessToken(tokenPayload);
    const refreshToken = generateRefreshToken(tokenPayload);

    res.status(201).json({
      accessToken,
      refreshToken,
      user: {
        id: savedUser.id,
        email: savedUser.email,
        username: savedUser.username,
      },
    });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/auth/login
router.post('/login', async (req: Request<{}, {}, LoginRequest>, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      res.status(400).json({ error: 'Email and password are required' });
      return;
    }

    const userRepository = AppDataSource.getRepository(User);
    const user = await userRepository.findOne({ where: { email } });

    if (!user) {
      res.status(401).json({ error: 'Invalid email or password' });
      return;
    }

    const isValidPassword = await comparePassword(password, user.passwordHash);
    if (!isValidPassword) {
      res.status(401).json({ error: 'Invalid email or password' });
      return;
    }

    const tokenPayload = { userId: user.id, email: user.email };
    const accessToken = generateAccessToken(tokenPayload);
    const refreshToken = generateRefreshToken(tokenPayload);

    res.json({
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/auth/refresh
router.post('/refresh', async (req: Request<{}, {}, RefreshRequest>, res: Response) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      res.status(400).json({ error: 'Refresh token is required' });
      return;
    }

    const payload = verifyRefreshToken(refreshToken);
    const userRepository = AppDataSource.getRepository(User);
    const user = await userRepository.findOne({ where: { id: payload.userId } });

    if (!user) {
      res.status(401).json({ error: 'User not found' });
      return;
    }

    const tokenPayload = { userId: user.id, email: user.email };
    const newAccessToken = generateAccessToken(tokenPayload);

    res.json({
      accessToken: newAccessToken,
    });
  } catch (error) {
    if (error instanceof Error && error.name === 'JsonWebTokenError') {
      res.status(401).json({ error: 'Invalid refresh token' });
      return;
    }
    if (error instanceof Error && error.name === 'TokenExpiredError') {
      res.status(401).json({ error: 'Refresh token expired' });
      return;
    }
    console.error('Refresh error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/auth/logout
router.post('/logout', async (req: Request, res: Response) => {
  // For JWT, logout is handled client-side by removing tokens
  // In a production app, you might want to maintain a blacklist of tokens
  res.json({ message: 'Logged out successfully' });
});

export default router;

