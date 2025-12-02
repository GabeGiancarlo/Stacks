import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
} from 'typeorm';
import { User } from './User';
import { Book } from './Book';

export enum BookStatus {
  WANT_TO_READ = 'want_to_read',
  READING = 'reading',
  READ = 'read',
}

@Entity('user_books')
export class UserBook {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ name: 'user_id' })
  userId!: number;

  @Column({ name: 'book_id' })
  bookId!: number;

  @Column({
    type: 'enum',
    enum: BookStatus,
    default: BookStatus.WANT_TO_READ,
  })
  status!: BookStatus;

  @CreateDateColumn({ name: 'added_at' })
  addedAt!: Date;

  @ManyToOne(() => User, (user) => user.userBooks)
  @JoinColumn({ name: 'user_id' })
  user!: User;

  @ManyToOne(() => Book, (book) => book.userBooks)
  @JoinColumn({ name: 'book_id' })
  book!: Book;
}

