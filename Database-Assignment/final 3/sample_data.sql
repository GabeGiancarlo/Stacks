-- Sample Data for Stacks Database
-- This file contains at least 3 rows of sample data for each table
-- Use this to populate the database after running schema.sql

USE stacks_db;

-- =====================================================
-- CORE ENTITIES - Sample Data
-- =====================================================

-- Users (at least 3 users)
INSERT INTO users (email, username, password_hash, display_name, bio, avatar_url, total_books_read, total_pages_read) VALUES
('alice@example.com', 'alice_reader', '$2y$10$example_hash_1', 'Alice Johnson', 'Avid fantasy reader and book collector', 'https://example.com/avatars/alice.jpg', 15, 4500),
('bob@example.com', 'bob_bookworm', '$2y$10$example_hash_2', 'Bob Smith', 'Science fiction enthusiast', 'https://example.com/avatars/bob.jpg', 8, 2400),
('charlie@example.com', 'charlie_lit', '$2y$10$example_hash_3', 'Charlie Brown', 'Literary fiction lover', 'https://example.com/avatars/charlie.jpg', 12, 3600);

-- Authors (at least 3 authors)
INSERT INTO authors (name, bio, photo_url, birth_date) VALUES
('J.K. Rowling', 'British author best known for the Harry Potter series', 'https://example.com/authors/rowling.jpg', '1965-07-31'),
('George R.R. Martin', 'American novelist and short story writer, author of A Song of Ice and Fire', 'https://example.com/authors/martin.jpg', '1948-09-20'),
('Jane Austen', 'English novelist known for her romantic fiction', 'https://example.com/authors/austen.jpg', '1775-12-16');

-- Genres (at least 3 genres)
INSERT INTO genres (name, parent_genre_id) VALUES
('Fiction', NULL),
('Fantasy', 1),
('Science Fiction', 1),
('Romance', 1),
('Mystery', 1);

-- Books (at least 3 books)
INSERT INTO books (isbn, title, subtitle, description, cover_image_url, publication_date, publisher, page_count, language, source_api) VALUES
('9780439708180', 'Harry Potter and the Philosopher''s Stone', NULL, 'The first book in the Harry Potter series', 'https://example.com/covers/hp1.jpg', '1997-06-26', 'Bloomsbury', 223, 'English', 'google_books'),
('9780553103540', 'A Game of Thrones', 'A Song of Ice and Fire: Book One', 'The first book in the epic fantasy series', 'https://example.com/covers/got1.jpg', '1996-08-01', 'Bantam Books', 694, 'English', 'google_books'),
('9780141439518', 'Pride and Prejudice', NULL, 'A romantic novel of manners', 'https://example.com/covers/pap.jpg', '1813-01-28', 'T. Egerton', 432, 'English', 'open_library'),
('9780061120084', 'To Kill a Mockingbird', NULL, 'A novel about racial inequality in the American South', 'https://example.com/covers/tkam.jpg', '1960-07-11', 'J.B. Lippincott & Co.', 281, 'English', 'google_books'),
('9781982137274', 'The Seven Husbands of Evelyn Hugo', NULL, 'A captivating novel about a reclusive Hollywood icon', 'https://example.com/covers/evelyn.jpg', '2017-06-13', 'Atria Books', 400, 'English', 'google_books');

-- Book-Author relationships
INSERT INTO book_authors (book_id, author_id, role, author_order) VALUES
(1, 1, 'author', 0),
(2, 2, 'author', 0),
(3, 3, 'author', 0);

-- Book-Genre relationships
INSERT INTO book_genres (book_id, genre_id, designation) VALUES
(1, 2, 'primary'),
(2, 2, 'primary'),
(3, 4, 'primary'),
(4, 1, 'primary'),
(5, 4, 'primary');

-- =====================================================
-- USER-BOOK RELATIONSHIPS - Sample Data
-- =====================================================

-- User_books (at least 3 entries)
INSERT INTO user_books (user_id, book_id, reading_status, rating, notes, current_page, completion_percentage, date_added, date_started, date_finished) VALUES
(1, 1, 'Read', 5, 'Amazing start to the series!', 223, 100.00, '2024-01-15', '2024-01-15', '2024-01-20'),
(1, 2, 'Currently Reading', 4, 'Very engaging, love the characters', 350, 50.43, '2024-02-01', '2024-02-01', NULL),
(2, 1, 'Read', 5, 'Childhood favorite, re-read for nostalgia', 223, 100.00, '2024-01-10', '2024-01-10', '2024-01-12'),
(2, 3, 'Want to Read', NULL, 'Classic I need to read', 0, 0.00, '2024-02-15', NULL, NULL),
(3, 2, 'Read', 5, 'Epic fantasy at its finest', 694, 100.00, '2023-12-01', '2023-12-01', '2023-12-20'),
(3, 4, 'Currently Reading', NULL, 'Powerful story', 150, 53.38, '2024-02-10', '2024-02-10', NULL);

-- Reading_sessions (at least 3 sessions)
INSERT INTO reading_sessions (user_book_id, session_date, duration_minutes, pages_read, progress_notes, reading_location) VALUES
(2, '2024-02-05', 45, 25, 'Great chapter about the Wall', 'Home'),
(2, '2024-02-06', 60, 30, 'Daenerys chapters are fascinating', 'Coffee Shop'),
(6, '2024-02-12', 30, 20, 'Atticus is such a great character', 'Library'),
(6, '2024-02-13', 40, 25, 'The trial scene is intense', 'Home');

-- Reading_history (at least 3 entries)
INSERT INTO reading_history (user_id, history_date, pages_read, cumulative_pages_read, reading_streak_days) VALUES
(1, '2024-02-05', 25, 4525, 5),
(1, '2024-02-06', 30, 4555, 6),
(2, '2024-01-10', 100, 100, 1),
(2, '2024-01-11', 123, 223, 2),
(3, '2024-02-12', 20, 3620, 3),
(3, '2024-02-13', 25, 3645, 4);

-- =====================================================
-- ORGANIZATION & SHELVES - Sample Data
-- =====================================================

-- Shelves (at least 3 shelves)
INSERT INTO shelves (user_id, name, description, shelf_style, display_order, privacy_setting) VALUES
(1, 'Fantasy Favorites', 'My favorite fantasy books', 'wood', 1, 'public'),
(1, 'To Read', 'Books I want to read next', 'modern', 2, 'private'),
(2, 'Classics', 'Classic literature collection', 'vintage', 1, 'friends_only'),
(3, 'Epic Series', 'Long fantasy and sci-fi series', 'wood', 1, 'public');

-- Shelf_books (at least 3 entries)
INSERT INTO shelf_books (shelf_id, book_id, display_position, shelf_notes, date_added) VALUES
(1, 1, 1, 'The book that started it all', '2024-01-20'),
(1, 2, 2, 'Currently reading, loving it', '2024-02-01'),
(3, 3, 1, 'A must-read classic', '2024-02-15'),
(4, 2, 1, 'Best fantasy series', '2023-12-20');

-- =====================================================
-- SOCIAL FEATURES - Sample Data
-- =====================================================

-- Reviews (at least 3 reviews)
INSERT INTO reviews (user_id, book_id, review_content, rating, helpful_votes, status, privacy_setting) VALUES
(1, 1, 'This book is absolutely magical! J.K. Rowling creates such a vivid world that you can''t help but get lost in it. The characters are well-developed and the plot is engaging from start to finish. A perfect introduction to the wizarding world.', 5, 12, 'published', 'public'),
(2, 1, 'Re-reading this as an adult was such a joy. The story holds up beautifully and I noticed so many details I missed as a child. Highly recommend for readers of all ages.', 5, 8, 'published', 'public'),
(3, 2, 'George R.R. Martin is a master storyteller. The multiple POVs work brilliantly and the political intrigue is fascinating. Can''t wait to continue the series!', 5, 15, 'published', 'public');

-- Friends (at least 3 friendships)
INSERT INTO friends (user1_id, user2_id, status, date_connected, last_interaction_at) VALUES
(1, 2, 'active', '2024-01-05', '2024-02-10'),
(1, 3, 'active', '2024-01-20', '2024-02-12'),
(2, 3, 'active', '2023-12-15', '2024-02-08');

-- Friend_requests (at least 3 requests - mix of statuses)
INSERT INTO friend_requests (requester_id, recipient_id, status, created_at, responded_at) VALUES
(1, 2, 'accepted', '2024-01-05 10:00:00', '2024-01-05 14:30:00'),
(1, 3, 'accepted', '2024-01-20 09:15:00', '2024-01-20 11:45:00'),
(2, 3, 'accepted', '2023-12-15 16:20:00', '2023-12-15 18:00:00');

-- Activities (at least 3 activities)
INSERT INTO activities (user_id, activity_type, target_book_id, target_review_id, activity_metadata, visibility) VALUES
(1, 'added_book', 1, NULL, '{"source": "isbn_scan"}', 'public'),
(1, 'finished_reading', 1, NULL, '{"pages_read": 223, "days_taken": 5}', 'public'),
(1, 'wrote_review', 1, 1, '{"rating": 5}', 'public'),
(2, 'added_book', 1, NULL, '{"source": "search"}', 'public'),
(3, 'finished_reading', 2, NULL, '{"pages_read": 694, "days_taken": 19}', 'public'),
(3, 'wrote_review', 2, 3, '{"rating": 5}', 'public');

-- =====================================================
-- BADGES & ACHIEVEMENTS - Sample Data
-- =====================================================

-- Badges (at least 3 badges)
INSERT INTO badges (name, description, category, tier, icon_url, unlock_criteria, points_value) VALUES
('First Book', 'Read your first book', 'Reading', 'Bronze', 'https://example.com/badges/first_book.png', '{"books_read": 1}', 10),
('Bookworm', 'Read 10 books', 'Reading', 'Silver', 'https://example.com/badges/bookworm.png', '{"books_read": 10}', 50),
('Page Turner', 'Read 1000 pages', 'Reading', 'Bronze', 'https://example.com/badges/page_turner.png', '{"pages_read": 1000}', 25),
('Social Reader', 'Write 5 reviews', 'Social', 'Silver', 'https://example.com/badges/social_reader.png', '{"reviews_written": 5}', 40),
('Friend Maker', 'Add 3 friends', 'Social', 'Bronze', 'https://example.com/badges/friend_maker.png', '{"friends_count": 3}', 15);

-- User_badges (at least 3 earned badges)
INSERT INTO user_badges (user_id, badge_id, date_earned, progress_to_next_tier, display_priority) VALUES
(1, 1, '2024-01-20', 0.00, 1),
(1, 3, '2024-01-25', 0.00, 2),
(2, 1, '2024-01-12', 0.00, 1),
(3, 1, '2023-12-20', 0.00, 1),
(3, 2, '2024-01-15', 0.00, 1),
(3, 3, '2024-01-10', 0.00, 2);

-- =====================================================
-- ADDITIONAL SUPPORTING ENTITIES - Sample Data
-- =====================================================

-- Notifications (at least 3 notifications)
INSERT INTO notifications (recipient_id, notification_type, associated_friend_request_id, associated_review_id, notification_content, is_read, read_at) VALUES
(2, 'friend_request', 1, NULL, 'alice_reader sent you a friend request', TRUE, '2024-01-05 14:30:00'),
(3, 'friend_request', 2, NULL, 'alice_reader sent you a friend request', TRUE, '2024-01-20 11:45:00'),
(1, 'activity_mention', NULL, NULL, 'bob_bookworm liked your review of Harry Potter and the Philosopher''s Stone', FALSE, NULL),
(2, 'badge_earned', NULL, NULL, 'Congratulations! You earned the First Book badge', TRUE, '2024-01-12 10:00:00'),
(3, 'badge_earned', NULL, NULL, 'Congratulations! You earned the Bookworm badge', FALSE, NULL);

-- =====================================================
-- Verification Queries
-- =====================================================

-- Uncomment these to verify data was inserted correctly:

-- SELECT 'Users' as table_name, COUNT(*) as row_count FROM users
-- UNION ALL
-- SELECT 'Books', COUNT(*) FROM books
-- UNION ALL
-- SELECT 'Authors', COUNT(*) FROM authors
-- UNION ALL
-- SELECT 'Genres', COUNT(*) FROM genres
-- UNION ALL
-- SELECT 'User_books', COUNT(*) FROM user_books
-- UNION ALL
-- SELECT 'Reading_sessions', COUNT(*) FROM reading_sessions
-- UNION ALL
-- SELECT 'Reading_history', COUNT(*) FROM reading_history
-- UNION ALL
-- SELECT 'Shelves', COUNT(*) FROM shelves
-- UNION ALL
-- SELECT 'Shelf_books', COUNT(*) FROM shelf_books
-- UNION ALL
-- SELECT 'Reviews', COUNT(*) FROM reviews
-- UNION ALL
-- SELECT 'Friends', COUNT(*) FROM friends
-- UNION ALL
-- SELECT 'Friend_requests', COUNT(*) FROM friend_requests
-- UNION ALL
-- SELECT 'Activities', COUNT(*) FROM activities
-- UNION ALL
-- SELECT 'Badges', COUNT(*) FROM badges
-- UNION ALL
-- SELECT 'User_badges', COUNT(*) FROM user_badges
-- UNION ALL
-- SELECT 'Book_authors', COUNT(*) FROM book_authors
-- UNION ALL
-- SELECT 'Book_genres', COUNT(*) FROM book_genres
-- UNION ALL
-- SELECT 'Notifications', COUNT(*) FROM notifications;

