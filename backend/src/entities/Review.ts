import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './User';
import { Book } from './Book';

@Entity('reviews')
export class Review {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ name: 'user_id' })
  userId!: number;

  @Column({ name: 'book_id' })
  bookId!: number;

  @Column({ type: 'int' })
  rating!: number;

  @Column({ name: 'review_text', type: 'text', nullable: true })
  reviewText?: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;

  @ManyToOne(() => User, (user) => user.reviews)
  @JoinColumn({ name: 'user_id' })
  user!: User;

  @ManyToOne(() => Book, (book) => book.reviews)
  @JoinColumn({ name: 'book_id' })
  book!: Book;
}

