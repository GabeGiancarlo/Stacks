-- Stacks Database Schema
-- This schema implements the ER Diagram relationships with proper foreign keys
-- MySQL Database Schema

-- Drop database if exists and create fresh database
DROP DATABASE IF EXISTS stacks_db;
CREATE DATABASE stacks_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE stacks_db;

-- =====================================================
-- CORE ENTITIES
-- =====================================================

-- Users table: User accounts and profiles
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(255),
    bio TEXT,
    avatar_url VARCHAR(500),
    privacy_settings JSON,
    total_books_read INT DEFAULT 0,
    total_pages_read INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Books table: Book metadata from Google Books & Open Library APIs
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(500) NOT NULL,
    subtitle VARCHAR(500),
    description TEXT,
    cover_image_url VARCHAR(500),
    publication_date DATE,
    publisher VARCHAR(255),
    page_count INT,
    language VARCHAR(50),
    source_api VARCHAR(50) COMMENT 'google_books or open_library',
    fetched_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_isbn (isbn),
    INDEX idx_title (title(100)),
    FULLTEXT INDEX idx_fulltext_title (title, subtitle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Authors table: Book authors
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT,
    photo_url VARCHAR(500),
    birth_date DATE,
    death_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Genres table: Book genres/categories with hierarchical support
CREATE TABLE genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    parent_genre_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_genre_id) REFERENCES genres(id) ON DELETE SET NULL,
    INDEX idx_parent_genre (parent_genre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- USER-BOOK RELATIONSHIPS
-- =====================================================

-- User_books table: User's collection and reading status
CREATE TABLE user_books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    reading_status ENUM('Read', 'Currently Reading', 'Want to Read', 'Owned') NOT NULL DEFAULT 'Owned',
    rating TINYINT CHECK (rating >= 1 AND rating <= 5),
    notes TEXT,
    current_page INT DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
    date_added DATE,
    date_started DATE,
    date_finished DATE,
    custom_metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_book (user_id, book_id),
    INDEX idx_user_status (user_id, reading_status),
    INDEX idx_user_book (user_id, book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reading_sessions table: Detailed reading progress tracking
CREATE TABLE reading_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_book_id INT NOT NULL,
    session_date DATE NOT NULL,
    duration_minutes INT,
    pages_read INT DEFAULT 0,
    progress_notes TEXT,
    reading_location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_book_id) REFERENCES user_books(id) ON DELETE CASCADE,
    INDEX idx_user_book_session (user_book_id, session_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reading_history table: Historical reading data aggregated by date
CREATE TABLE reading_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    history_date DATE NOT NULL,
    pages_read INT DEFAULT 0,
    cumulative_pages_read INT DEFAULT 0,
    reading_streak_days INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_history_date (user_id, history_date),
    INDEX idx_user_history (user_id, history_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ORGANIZATION & SHELVES
-- =====================================================

-- Shelves table: Custom shelves created by users
CREATE TABLE shelves (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    shelf_style ENUM('wood', 'modern', 'vintage', 'white_minimal') DEFAULT 'wood',
    display_order INT DEFAULT 0,
    privacy_setting ENUM('public', 'private', 'friends_only') DEFAULT 'private',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_shelf (user_id, display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Shelf_books table: Books placed on shelves (many-to-many)
CREATE TABLE shelf_books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shelf_id INT NOT NULL,
    book_id INT NOT NULL,
    display_position INT DEFAULT 0,
    shelf_notes TEXT,
    date_added DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shelf_id) REFERENCES shelves(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE KEY uk_shelf_book_position (shelf_id, book_id, display_position),
    INDEX idx_shelf_position (shelf_id, display_position)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- SOCIAL FEATURES
-- =====================================================

-- Reviews table: User reviews of books
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    review_content TEXT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    helpful_votes INT DEFAULT 0,
    status ENUM('draft', 'published') DEFAULT 'published',
    privacy_setting ENUM('public', 'private', 'friends_only') DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_book_review (user_id, book_id),
    INDEX idx_book_rating (book_id, rating),
    INDEX idx_user_reviews (user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Friends table: Friend connections between users (bidirectional)
CREATE TABLE friends (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user1_id INT NOT NULL,
    user2_id INT NOT NULL,
    status ENUM('active', 'blocked') DEFAULT 'active',
    date_connected DATE,
    last_interaction_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user1_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (user2_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_friendship (user1_id, user2_id),
    CHECK (user1_id < user2_id),
    INDEX idx_user1_friends (user1_id, status),
    INDEX idx_user2_friends (user2_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Friend_requests table: Pending friend requests
CREATE TABLE friend_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    requester_id INT NOT NULL,
    recipient_id INT NOT NULL,
    status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP NULL,
    FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_friend_request (requester_id, recipient_id),
    CHECK (requester_id != recipient_id),
    INDEX idx_recipient_status (recipient_id, status),
    INDEX idx_requester_status (requester_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Activities table: Activity feed entries
CREATE TABLE activities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL COMMENT 'added_book, finished_reading, wrote_review, earned_badge',
    target_book_id INT NULL,
    target_review_id INT NULL,
    target_badge_id INT NULL,
    activity_metadata JSON,
    visibility ENUM('public', 'private', 'friends_only') DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (target_book_id) REFERENCES books(id) ON DELETE SET NULL,
    FOREIGN KEY (target_review_id) REFERENCES reviews(id) ON DELETE SET NULL,
    FOREIGN KEY (target_badge_id) REFERENCES badges(id) ON DELETE SET NULL,
    INDEX idx_user_activity (user_id, created_at),
    INDEX idx_activity_type (activity_type, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- BADGES & ACHIEVEMENTS
-- =====================================================

-- Badges table: Badge definitions
CREATE TABLE badges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    category ENUM('Reading', 'Collection', 'Social', 'Discovery') NOT NULL,
    tier ENUM('Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond') NOT NULL,
    icon_url VARCHAR(500),
    unlock_criteria JSON,
    points_value INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_tier (category, tier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User_badges table: Badges earned by users
CREATE TABLE user_badges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    badge_id INT NOT NULL,
    date_earned DATE NOT NULL,
    progress_to_next_tier DECIMAL(5,2) DEFAULT 0.00 CHECK (progress_to_next_tier >= 0 AND progress_to_next_tier <= 100),
    display_priority INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_badge (user_id, badge_id),
    INDEX idx_user_badges (user_id, date_earned),
    INDEX idx_badge_users (badge_id, date_earned)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- MANY-TO-MANY RELATIONSHIP TABLES
-- =====================================================

-- Book_authors table: Many-to-many relationship between books and authors
CREATE TABLE book_authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    role VARCHAR(50) DEFAULT 'author' COMMENT 'author, co-author, illustrator, editor, translator',
    author_order INT DEFAULT 0 COMMENT 'Order for display (0 = primary author)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE,
    UNIQUE KEY uk_book_author (book_id, author_id),
    INDEX idx_book_authors (book_id, author_order),
    INDEX idx_author_books (author_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Book_genres table: Many-to-many relationship between books and genres
CREATE TABLE book_genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    genre_id INT NOT NULL,
    designation ENUM('primary', 'secondary') DEFAULT 'primary',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE,
    UNIQUE KEY uk_book_genre (book_id, genre_id),
    INDEX idx_book_genres (book_id, designation),
    INDEX idx_genre_books (genre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ADDITIONAL SUPPORTING ENTITIES
-- =====================================================

-- Notifications table: User notifications
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_id INT NOT NULL,
    notification_type VARCHAR(50) NOT NULL COMMENT 'friend_request, review_comment, activity_mention, badge_earned',
    associated_friend_request_id INT NULL,
    associated_review_id INT NULL,
    notification_content TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (associated_friend_request_id) REFERENCES friend_requests(id) ON DELETE SET NULL,
    FOREIGN KEY (associated_review_id) REFERENCES reviews(id) ON DELETE SET NULL,
    INDEX idx_recipient_read (recipient_id, is_read, created_at),
    INDEX idx_notification_type (notification_type, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- FOREIGN KEY VERIFICATION
-- =====================================================

-- All foreign keys have been properly defined above:
-- 
-- users references: none (root entity)
-- books references: none (root entity)
-- authors references: none (root entity)
-- genres references: genres(parent_genre_id) - self-referential
--
-- user_books references: users(user_id), books(book_id)
-- reading_sessions references: user_books(user_book_id)
-- reading_history references: users(user_id)
-- shelves references: users(user_id)
-- shelf_books references: shelves(shelf_id), books(book_id)
-- reviews references: users(user_id), books(book_id)
-- friends references: users(user1_id), users(user2_id)
-- friend_requests references: users(requester_id), users(recipient_id)
-- activities references: users(user_id), books(target_book_id), reviews(target_review_id), badges(target_badge_id)
-- badges references: none (root entity)
-- user_badges references: users(user_id), badges(badge_id)
-- book_authors references: books(book_id), authors(author_id)
-- book_genres references: books(book_id), genres(genre_id)
-- notifications references: users(recipient_id), friend_requests(associated_friend_request_id), reviews(associated_review_id)

