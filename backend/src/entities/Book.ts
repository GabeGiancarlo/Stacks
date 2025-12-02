import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToMany,
} from 'typeorm';
import { UserBook } from './UserBook';
import { Review } from './Review';

@Entity('books')
export class Book {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ nullable: true, unique: true })
  isbn?: string;

  @Column()
  title!: string;

  @Column()
  author!: string;

  @Column({ name: 'cover_url', nullable: true })
  coverUrl?: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ name: 'published_year', nullable: true })
  publishedYear?: number;

  @OneToMany(() => UserBook, (userBook) => userBook.book)
  userBooks!: UserBook[];

  @OneToMany(() => Review, (review) => review.book)
  reviews!: Review[];
}

