import { DataSource } from 'typeorm';
import { User } from './entities/User';
import { Book } from './entities/Book';
import { UserBook } from './entities/UserBook';
import { Review } from './entities/Review';
import { Badge } from './entities/Badge';
import { UserBadge } from './entities/UserBadge';

export const AppDataSource = new DataSource({
  type: 'mysql',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  username: process.env.DB_USER || 'stacks_user',
  password: process.env.DB_PASSWORD || 'secure_password',
  database: process.env.DB_NAME || 'stacks_db',
  synchronize: false, // Use migrations instead
  logging: process.env.NODE_ENV === 'development',
  entities: [User, Book, UserBook, Review, Badge, UserBadge],
  migrations: process.env.NODE_ENV === 'production' 
    ? ['dist/migrations/**/*.js']
    : ['src/migrations/**/*.ts'],
  subscribers: process.env.NODE_ENV === 'production'
    ? ['dist/subscribers/**/*.js']
    : ['src/subscribers/**/*.ts'],
});

