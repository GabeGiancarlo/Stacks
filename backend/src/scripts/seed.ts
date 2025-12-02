import 'reflect-metadata';
import dotenv from 'dotenv';
import { AppDataSource } from '../data-source';
import { User } from '../entities/User';
import { Book } from '../entities/Book';
import { UserBook, BookStatus } from '../entities/UserBook';
import { Review } from '../entities/Review';
import { Badge, BadgeTier } from '../entities/Badge';
import { UserBadge } from '../entities/UserBadge';
import { hashPassword } from '../utils/auth';

dotenv.config();

async function seed() {
  try {
    await AppDataSource.initialize();
    console.log('Database connected');

    const userRepository = AppDataSource.getRepository(User);
    const bookRepository = AppDataSource.getRepository(Book);
    const userBookRepository = AppDataSource.getRepository(UserBook);
    const reviewRepository = AppDataSource.getRepository(Review);
    const badgeRepository = AppDataSource.getRepository(Badge);
    const userBadgeRepository = AppDataSource.getRepository(UserBadge);

    // Clear existing data (optional - comment out if you want to preserve data)
    console.log('Clearing existing data...');
    await userBadgeRepository.delete({});
    await reviewRepository.delete({});
    await userBookRepository.delete({});
    await badgeRepository.delete({});
    await bookRepository.delete({});
    await userRepository.delete({});

    // Create test users
    console.log('Creating test users...');
    const user1Password = await hashPassword('password123');
    const user1 = userRepository.create({
      email: 'user@test.com',
      passwordHash: user1Password,
      username: 'testuser',
    });
    await userRepository.save(user1);

    const user2Password = await hashPassword('admin123');
    const user2 = userRepository.create({
      email: 'admin@test.com',
      passwordHash: user2Password,
      username: 'admin',
    });
    await userRepository.save(user2);

    // Create sample books
    console.log('Creating sample books...');
    const sampleBooks = [
      {
        isbn: '9780593099322',
        title: 'Dune',
        author: 'Frank Herbert',
        description: 'Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides.',
        publishedYear: 1965,
      },
      {
        isbn: '9780439064873',
        title: 'Harry Potter and the Chamber of Secrets',
        author: 'J.K. Rowling',
        description: 'The second book in the Harry Potter series.',
        publishedYear: 1998,
      },
      {
        isbn: '9780143127741',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        description: 'A classic American novel about the Jazz Age.',
        publishedYear: 1925,
      },
      {
        isbn: '9781982137274',
        title: 'Project Hail Mary',
        author: 'Andy Weir',
        description: 'A lone astronaut must save the earth from disaster.',
        publishedYear: 2021,
      },
      {
        isbn: '9780316251309',
        title: 'The Three-Body Problem',
        author: 'Liu Cixin',
        description: 'A science fiction novel about humanity\'s first contact with an alien civilization.',
        publishedYear: 2008,
      },
      {
        isbn: '9780061120084',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        description: 'A gripping tale of racial injustice and loss of innocence.',
        publishedYear: 1960,
      },
      {
        isbn: '9780141439563',
        title: 'Pride and Prejudice',
        author: 'Jane Austen',
        description: 'A romantic novel of manners written by Jane Austen.',
        publishedYear: 1813,
      },
      {
        isbn: '9780451524935',
        title: '1984',
        author: 'George Orwell',
        description: 'A dystopian social science fiction novel.',
        publishedYear: 1949,
      },
      {
        isbn: '9780060850524',
        title: 'Brave New World',
        author: 'Aldous Huxley',
        description: 'A dystopian novel set in a futuristic World State.',
        publishedYear: 1932,
      },
      {
        isbn: '9780143039433',
        title: 'The Catcher in the Rye',
        author: 'J.D. Salinger',
        description: 'A controversial novel about teenage rebellion.',
        publishedYear: 1951,
      },
      {
        isbn: '9780385494244',
        title: 'The Handmaid\'s Tale',
        author: 'Margaret Atwood',
        description: 'A dystopian novel set in a totalitarian theocracy.',
        publishedYear: 1985,
      },
      {
        isbn: '9780062561029',
        title: 'The Seven Husbands of Evelyn Hugo',
        author: 'Taylor Jenkins Reid',
        description: 'A captivating novel about a reclusive Hollywood icon.',
        publishedYear: 2017,
      },
      {
        isbn: '9781250178632',
        title: 'The Midnight Library',
        author: 'Matt Haig',
        description: 'A novel about a library that contains books with different versions of one\'s life.',
        publishedYear: 2020,
      },
      {
        isbn: '9780525559474',
        title: 'The Invisible Man',
        author: 'Ralph Ellison',
        description: 'A groundbreaking novel about race and identity in America.',
        publishedYear: 1952,
      },
      {
        isbn: '9780061122415',
        title: 'The Book Thief',
        author: 'Markus Zusak',
        description: 'A story about a young girl living in Nazi Germany.',
        publishedYear: 2005,
      },
    ];

    const savedBooks: Book[] = [];
    for (const bookData of sampleBooks) {
      const book = bookRepository.create(bookData);
      const saved = await bookRepository.save(book);
      savedBooks.push(saved);
    }

    // Add books to user1's library
    console.log('Adding books to user library...');
    for (let i = 0; i < 10; i++) {
      const userBook = userBookRepository.create({
        userId: user1.id,
        bookId: savedBooks[i].id,
        status: i < 5 ? BookStatus.READ : BookStatus.READING,
      });
      await userBookRepository.save(userBook);
    }

    // Create sample reviews
    console.log('Creating sample reviews...');
    const review1 = reviewRepository.create({
      userId: user1.id,
      bookId: savedBooks[0].id,
      rating: 5,
      reviewText: 'An absolute masterpiece! The world-building is incredible.',
    });
    await reviewRepository.save(review1);

    const review2 = reviewRepository.create({
      userId: user1.id,
      bookId: savedBooks[1].id,
      rating: 4,
      reviewText: 'Great continuation of the series. Loved the mystery element.',
    });
    await reviewRepository.save(review2);

    const review3 = reviewRepository.create({
      userId: user1.id,
      bookId: savedBooks[2].id,
      rating: 5,
      reviewText: 'A timeless classic. The prose is beautiful.',
    });
    await reviewRepository.save(review3);

    // Create badges
    console.log('Creating badges...');
    const badges = [
      {
        name: 'First Book',
        tier: BadgeTier.BRONZE,
        criteria: 'Add your first book to the library',
      },
      {
        name: 'Bookworm',
        tier: BadgeTier.SILVER,
        criteria: 'Add 10 books to your library',
      },
      {
        name: 'Avid Reader',
        tier: BadgeTier.GOLD,
        criteria: 'Add 50 books to your library',
      },
      {
        name: 'Literary Master',
        tier: BadgeTier.PLATINUM,
        criteria: 'Add 100 books to your library',
      },
      {
        name: 'Reviewer',
        tier: BadgeTier.BRONZE,
        criteria: 'Write your first review',
      },
      {
        name: 'Critic',
        tier: BadgeTier.SILVER,
        criteria: 'Write 10 reviews',
      },
      {
        name: 'Book Critic',
        tier: BadgeTier.GOLD,
        criteria: 'Write 50 reviews',
      },
    ];

    const savedBadges: Badge[] = [];
    for (const badgeData of badges) {
      const badge = badgeRepository.create(badgeData);
      const saved = await badgeRepository.save(badge);
      savedBadges.push(saved);
    }

    // Award badges to user1
    console.log('Awarding badges...');
    const userBadge1 = userBadgeRepository.create({
      userId: user1.id,
      badgeId: savedBadges[0].id, // First Book
    });
    await userBadgeRepository.save(userBadge1);

    const userBadge2 = userBadgeRepository.create({
      userId: user1.id,
      badgeId: savedBadges[4].id, // Reviewer
    });
    await userBadgeRepository.save(userBadge2);

    console.log('Seeding completed successfully!');
    console.log('\nTest credentials:');
    console.log('User 1: user@test.com / password123');
    console.log('User 2: admin@test.com / admin123');
    console.log(`\nCreated ${savedBooks.length} books, ${badges.length} badges`);

    await AppDataSource.destroy();
    process.exit(0);
  } catch (error) {
    console.error('Seeding error:', error);
    await AppDataSource.destroy();
    process.exit(1);
  }
}

seed();

