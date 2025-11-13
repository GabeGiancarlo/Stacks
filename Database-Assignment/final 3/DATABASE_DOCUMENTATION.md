# Stacks Database Documentation
## Table Descriptions and User Interaction Patterns

This document describes all database tables in the Stacks application and explains how users will interact with them through the frontend interface. Each section groups related tables and queries that will be triggered by similar UI actions.

---

## 1. Core User Management Tables

### `users` Table
**Purpose**: Stores user account information, authentication credentials, and profile data.

**Key Attributes**:
- `id`: Primary key for user identification
- `email`, `username`: Unique identifiers for login
- `password_hash`: Secure password storage
- `display_name`, `bio`, `avatar_url`: Profile information
- `total_books_read`, `total_pages_read`: Aggregated reading statistics
- `privacy_settings`: JSON field for user privacy preferences

**User Interactions**:

1. **User Registration** (SignUpView)
   - **Frontend Action**: User fills out registration form with email, username, password
   - **SQL Query**: 
     ```sql
     INSERT INTO users (email, username, password_hash, display_name, created_at)
     VALUES (?, ?, ?, ?, NOW());
     ```

2. **User Login** (LoginView)
   - **Frontend Action**: User enters credentials and taps "Sign In"
   - **SQL Queries**:
     ```sql
     SELECT id, email, username, password_hash, display_name, bio, avatar_url, 
            total_books_read, total_pages_read, privacy_settings
     FROM users 
     WHERE email = ? OR username = ?;
     
     UPDATE users SET last_login_at = NOW() WHERE id = ?;
     ```

3. **Profile View** (ProfileView)
   - **Frontend Action**: User views their own profile or another user's public profile
   - **SQL Query**:
     ```sql
     SELECT id, username, display_name, bio, avatar_url, total_books_read, 
            total_pages_read, created_at
     FROM users 
     WHERE id = ?;
     ```

4. **Profile Update** (ProfileView - Edit Mode)
   - **Frontend Action**: User edits their display name, bio, or avatar
   - **SQL Query**:
     ```sql
     UPDATE users 
     SET display_name = ?, bio = ?, avatar_url = ?, updated_at = NOW()
     WHERE id = ?;
     ```

---

## 2. Book Catalog Tables

### `books` Table
**Purpose**: Stores book metadata fetched from Google Books and Open Library APIs.

**Key Attributes**:
- `id`: Primary key
- `isbn`: Unique identifier (unique constraint)
- `title`, `subtitle`, `description`: Book information
- `cover_image_url`: Book cover image
- `publication_date`, `publisher`, `page_count`: Publication details
- `source_api`: Tracks which API provided the data

### `authors` Table
**Purpose**: Stores author information.

**Key Attributes**:
- `id`: Primary key
- `name`: Author name
- `bio`, `photo_url`: Author details
- `birth_date`, `death_date`: Author life dates

### `book_authors` Table
**Purpose**: Many-to-many relationship between books and authors.

**Key Attributes**:
- `book_id`, `author_id`: Foreign keys
- `role`: Author role (author, co-author, illustrator, etc.)
- `author_order`: Display order (0 = primary author)

### `genres` Table
**Purpose**: Hierarchical genre/category system for books.

**Key Attributes**:
- `id`: Primary key
- `name`: Genre name (unique)
- `parent_genre_id`: Self-referential foreign key for hierarchy

### `book_genres` Table
**Purpose**: Many-to-many relationship between books and genres.

**Key Attributes**:
- `book_id`, `genre_id`: Foreign keys
- `designation`: Primary or secondary genre

**User Interactions**:

1. **Scan ISBN** (ScanView)
   - **Frontend Action**: User scans a book's ISBN barcode
   - **SQL Queries**:
     ```sql
     -- Check if book already exists
     SELECT id, title, cover_image_url, page_count 
     FROM books 
     WHERE isbn = ?;
     
     -- If not found, after API fetch:
     INSERT INTO books (isbn, title, subtitle, description, cover_image_url, 
                       publication_date, publisher, page_count, language, 
                       source_api, fetched_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW());
     
     -- Insert authors (if new)
     INSERT INTO authors (name, bio, photo_url) 
     VALUES (?, ?, ?) 
     ON DUPLICATE KEY UPDATE name = name;
     
     INSERT INTO book_authors (book_id, author_id, role, author_order)
     VALUES (?, ?, 'author', ?);
     
     -- Insert genres
     INSERT INTO book_genres (book_id, genre_id, designation)
     VALUES (?, ?, 'primary');
     ```

2. **Book Search** (ExploreView)
   - **Frontend Action**: User searches for books by title or author
   - **SQL Query**:
     ```sql
     SELECT b.id, b.isbn, b.title, b.cover_image_url, b.page_count,
            GROUP_CONCAT(DISTINCT a.name SEPARATOR ', ') as authors
     FROM books b
     LEFT JOIN book_authors ba ON b.id = ba.book_id
     LEFT JOIN authors a ON ba.author_id = a.id
     WHERE b.title LIKE ? OR a.name LIKE ?
     GROUP BY b.id
     LIMIT 20;
     ```

3. **Book Detail View** (BookDetailView)
   - **Frontend Action**: User taps on a book to see full details
   - **SQL Queries**:
     ```sql
     -- Get book details
     SELECT b.*, 
            GROUP_CONCAT(DISTINCT a.name SEPARATOR ', ') as authors,
            GROUP_CONCAT(DISTINCT g.name SEPARATOR ', ') as genres
     FROM books b
     LEFT JOIN book_authors ba ON b.id = ba.book_id
     LEFT JOIN authors a ON ba.author_id = a.id
     LEFT JOIN book_genres bg ON b.id = bg.book_id
     LEFT JOIN genres g ON bg.genre_id = g.id
     WHERE b.id = ?
     GROUP BY b.id;
     
     -- Get user's relationship with this book
     SELECT reading_status, rating, notes, current_page, completion_percentage
     FROM user_books
     WHERE user_id = ? AND book_id = ?;
     ```

---

## 3. User Book Collection Tables

### `user_books` Table
**Purpose**: Tracks books in a user's collection with reading status and progress.

**Key Attributes**:
- `id`: Primary key
- `user_id`, `book_id`: Foreign keys (unique constraint: one entry per user-book pair)
- `reading_status`: ENUM ('Read', 'Currently Reading', 'Want to Read', 'Owned')
- `rating`: 1-5 star rating
- `notes`: User's personal notes
- `current_page`, `completion_percentage`: Reading progress
- `date_added`, `date_started`, `date_finished`: Timeline tracking

### `reading_sessions` Table
**Purpose**: Detailed tracking of individual reading sessions.

**Key Attributes**:
- `id`: Primary key
- `user_book_id`: Foreign key to user_books
- `session_date`: Date of reading session
- `duration_minutes`: How long user read
- `pages_read`: Pages read in this session
- `progress_notes`: Optional notes about the session

### `reading_history` Table
**Purpose**: Aggregated daily reading statistics for streaks and analytics.

**Key Attributes**:
- `id`: Primary key
- `user_id`: Foreign key
- `history_date`: Date of the reading activity
- `pages_read`: Pages read on this date
- `cumulative_pages_read`: Running total
- `reading_streak_days`: Current streak count

**User Interactions**:

1. **Add Book to Library** (BookDetailView - "Add to Library" button)
   - **Frontend Action**: User taps "Add to Library" after scanning or searching
   - **SQL Queries**:
     ```sql
     INSERT INTO user_books (user_id, book_id, reading_status, date_added)
     VALUES (?, ?, 'Owned', CURDATE())
     ON DUPLICATE KEY UPDATE date_added = CURDATE();
     
     -- Create activity entry
     INSERT INTO activities (user_id, activity_type, target_book_id, visibility)
     VALUES (?, 'added_book', ?, 'public');
     ```

2. **Update Reading Status** (LibraryView - Status dropdown)
   - **Frontend Action**: User changes book status (e.g., "Want to Read" → "Currently Reading")
   - **SQL Query**:
     ```sql
     UPDATE user_books 
     SET reading_status = ?, 
         date_started = CASE WHEN ? = 'Currently Reading' AND date_started IS NULL 
                            THEN CURDATE() ELSE date_started END,
         updated_at = NOW()
     WHERE user_id = ? AND book_id = ?;
     ```

3. **Log Reading Session** (LibraryView - "Log Reading" button)
   - **Frontend Action**: User records a reading session with pages read and duration
   - **SQL Queries**:
     ```sql
     -- Insert reading session
     INSERT INTO reading_sessions (user_book_id, session_date, duration_minutes, 
                                   pages_read, progress_notes)
     VALUES (?, CURDATE(), ?, ?, ?);
     
     -- Update user_books progress
     UPDATE user_books 
     SET current_page = current_page + ?,
         completion_percentage = ((current_page + ?) / 
         (SELECT page_count FROM books WHERE id = ?)) * 100,
         updated_at = NOW()
     WHERE id = ?;
     
     -- Update or insert reading history
     INSERT INTO reading_history (user_id, history_date, pages_read, 
                                 cumulative_pages_read, reading_streak_days)
     VALUES (?, CURDATE(), ?, 
             (SELECT COALESCE(MAX(cumulative_pages_read), 0) + ? 
              FROM reading_history WHERE user_id = ?),
             ?)
     ON DUPLICATE KEY UPDATE 
         pages_read = pages_read + VALUES(pages_read),
         cumulative_pages_read = cumulative_pages_read + VALUES(pages_read),
         reading_streak_days = ?,
         updated_at = NOW();
     
     -- Update user totals
     UPDATE users 
     SET total_pages_read = total_pages_read + ?
     WHERE id = ?;
     ```

4. **Mark Book as Finished** (LibraryView - "Mark as Read" button)
   - **Frontend Action**: User completes a book
   - **SQL Queries**:
     ```sql
     UPDATE user_books 
     SET reading_status = 'Read',
         date_finished = CURDATE(),
         completion_percentage = 100.00,
         current_page = (SELECT page_count FROM books WHERE id = ?),
         updated_at = NOW()
     WHERE user_id = ? AND book_id = ?;
     
     UPDATE users 
     SET total_books_read = total_books_read + 1
     WHERE id = ?;
     
     INSERT INTO activities (user_id, activity_type, target_book_id, visibility)
     VALUES (?, 'finished_reading', ?, 'public');
     ```

5. **View Library** (LibraryView)
   - **Frontend Action**: User views their book collection
   - **SQL Query**:
     ```sql
     SELECT ub.id, ub.reading_status, ub.rating, ub.current_page, 
            ub.completion_percentage, ub.date_added,
            b.id as book_id, b.title, b.cover_image_url, b.page_count,
            GROUP_CONCAT(DISTINCT a.name SEPARATOR ', ') as authors
     FROM user_books ub
     JOIN books b ON ub.book_id = b.id
     LEFT JOIN book_authors ba ON b.id = ba.book_id
     LEFT JOIN authors a ON ba.author_id = a.id
     WHERE ub.user_id = ?
     GROUP BY ub.id
     ORDER BY ub.date_added DESC;
     ```

6. **View Reading Statistics** (ProfileView - Stats section)
   - **Frontend Action**: User views their reading stats and streaks
   - **SQL Queries**:
     ```sql
     -- Get user totals
     SELECT total_books_read, total_pages_read 
     FROM users 
     WHERE id = ?;
     
     -- Get reading streak
     SELECT reading_streak_days, history_date
     FROM reading_history
     WHERE user_id = ?
     ORDER BY history_date DESC
     LIMIT 1;
     
     -- Get books by status
     SELECT reading_status, COUNT(*) as count
     FROM user_books
     WHERE user_id = ?
     GROUP BY reading_status;
     ```

---

## 4. Shelf Organization Tables

### `shelves` Table
**Purpose**: Custom shelves created by users to organize their books.

**Key Attributes**:
- `id`: Primary key
- `user_id`: Foreign key to users
- `name`: Shelf name
- `description`: Optional shelf description
- `shelf_style`: Visual style (wood, modern, vintage, white_minimal)
- `display_order`: Order for UI display
- `privacy_setting`: Visibility control

### `shelf_books` Table
**Purpose**: Many-to-many relationship between shelves and books.

**Key Attributes**:
- `id`: Primary key
- `shelf_id`, `book_id`: Foreign keys
- `display_position`: Order of books on the shelf
- `shelf_notes`: Optional notes about this book on this shelf

**User Interactions**:

1. **Create Shelf** (LibraryView - "New Shelf" button)
   - **Frontend Action**: User creates a new custom shelf
   - **SQL Query**:
     ```sql
     INSERT INTO shelves (user_id, name, description, shelf_style, display_order, 
                          privacy_setting)
     VALUES (?, ?, ?, 'wood', 
            (SELECT COALESCE(MAX(display_order), 0) + 1 FROM shelves WHERE user_id = ?),
            'private');
     ```

2. **Add Book to Shelf** (BookDetailView - "Add to Shelf" dropdown)
   - **Frontend Action**: User selects a shelf to add the book to
   - **SQL Query**:
     ```sql
     INSERT INTO shelf_books (shelf_id, book_id, display_position, date_added)
     VALUES (?, ?, 
            (SELECT COALESCE(MAX(display_position), 0) + 1 
             FROM shelf_books WHERE shelf_id = ?),
            CURDATE())
     ON DUPLICATE KEY UPDATE date_added = CURDATE();
     ```

3. **View Shelf** (LibraryView - Shelf selection)
   - **Frontend Action**: User taps on a shelf to view its books
   - **SQL Query**:
     ```sql
     SELECT sb.id, sb.display_position, sb.shelf_notes,
            b.id as book_id, b.title, b.cover_image_url,
            GROUP_CONCAT(DISTINCT a.name SEPARATOR ', ') as authors
     FROM shelf_books sb
     JOIN books b ON sb.book_id = b.id
     LEFT JOIN book_authors ba ON b.id = ba.book_id
     LEFT JOIN authors a ON ba.author_id = a.id
     WHERE sb.shelf_id = ?
     GROUP BY sb.id
     ORDER BY sb.display_position ASC;
     ```

4. **Reorder Books on Shelf** (LibraryView - Drag and drop)
   - **Frontend Action**: User drags books to reorder them on a shelf
   - **SQL Query**:
     ```sql
     UPDATE shelf_books 
     SET display_position = ?
     WHERE id = ?;
     ```

---

## 5. Review and Social Tables

### `reviews` Table
**Purpose**: User-written reviews of books.

**Key Attributes**:
- `id`: Primary key
- `user_id`, `book_id`: Foreign keys (unique constraint: one review per user per book)
- `review_content`: Review text
- `rating`: 1-5 star rating
- `helpful_votes`: Count of helpful votes
- `status`: Draft or published
- `privacy_setting`: Visibility control

**User Interactions**:

1. **Write Review** (ReviewWriteView)
   - **Frontend Action**: User writes and submits a book review
   - **SQL Queries**:
     ```sql
     INSERT INTO reviews (user_id, book_id, review_content, rating, status, 
                         privacy_setting)
     VALUES (?, ?, ?, ?, 'published', 'public')
     ON DUPLICATE KEY UPDATE 
         review_content = VALUES(review_content),
         rating = VALUES(rating),
         updated_at = NOW();
     
     -- Update user_books rating if different
     UPDATE user_books 
     SET rating = ?
     WHERE user_id = ? AND book_id = ?;
     
     -- Create activity
     INSERT INTO activities (user_id, activity_type, target_book_id, 
                            target_review_id, visibility)
     VALUES (?, 'wrote_review', ?, LAST_INSERT_ID(), 'public');
     ```

2. **View Book Reviews** (BookDetailView - Reviews section)
   - **Frontend Action**: User scrolls to see reviews for a book
   - **SQL Query**:
     ```sql
     SELECT r.id, r.review_content, r.rating, r.helpful_votes, r.created_at,
            u.id as user_id, u.username, u.display_name, u.avatar_url
     FROM reviews r
     JOIN users u ON r.user_id = u.id
     WHERE r.book_id = ? AND r.status = 'published'
     ORDER BY r.helpful_votes DESC, r.created_at DESC
     LIMIT 20;
     ```

3. **View User's Reviews** (ProfileView - Reviews tab)
   - **Frontend Action**: User views their own or another user's reviews
   - **SQL Query**:
     ```sql
     SELECT r.id, r.review_content, r.rating, r.helpful_votes, r.created_at,
            b.id as book_id, b.title, b.cover_image_url
     FROM reviews r
     JOIN books b ON r.book_id = b.id
     WHERE r.user_id = ? AND r.status = 'published'
     ORDER BY r.created_at DESC;
     ```

---

## 6. Friend and Social Network Tables

### `friends` Table
**Purpose**: Bidirectional friend relationships between users.

**Key Attributes**:
- `id`: Primary key
- `user1_id`, `user2_id`: Foreign keys (user1_id < user2_id constraint)
- `status`: Active or blocked
- `date_connected`: When friendship was established

### `friend_requests` Table
**Purpose**: Pending friend requests between users.

**Key Attributes**:
- `id`: Primary key
- `requester_id`, `recipient_id`: Foreign keys
- `status`: Pending, accepted, or rejected
- `created_at`, `responded_at`: Timestamps

**User Interactions**:

1. **Send Friend Request** (ProfileView - "Add Friend" button)
   - **Frontend Action**: User taps "Add Friend" on another user's profile
   - **SQL Query**:
     ```sql
     INSERT INTO friend_requests (requester_id, recipient_id, status)
     VALUES (?, ?, 'pending');
     
     -- Create notification
     INSERT INTO notifications (recipient_id, notification_type, 
                               associated_friend_request_id, notification_content)
     VALUES (?, 'friend_request', LAST_INSERT_ID(), 
            CONCAT((SELECT username FROM users WHERE id = ?), ' sent you a friend request'));
     ```

2. **Accept Friend Request** (ProfileView - Notifications)
   - **Frontend Action**: User taps "Accept" on a friend request notification
   - **SQL Queries**:
     ```sql
     -- Update friend request
     UPDATE friend_requests 
     SET status = 'accepted', responded_at = NOW()
     WHERE id = ?;
     
     -- Create friendship (ensuring user1_id < user2_id)
     INSERT INTO friends (user1_id, user2_id, status, date_connected)
     VALUES (LEAST(?, ?), GREATEST(?, ?), 'active', CURDATE())
     ON DUPLICATE KEY UPDATE status = 'active';
     
     -- Update notification
     UPDATE notifications 
     SET is_read = TRUE, read_at = NOW()
     WHERE associated_friend_request_id = ?;
     ```

3. **View Friends List** (ProfileView - Friends tab)
   - **Frontend Action**: User views their friends list
   - **SQL Query**:
     ```sql
     SELECT u.id, u.username, u.display_name, u.avatar_url, f.date_connected
     FROM friends f
     JOIN users u ON (f.user1_id = u.id AND f.user1_id != ?) 
                 OR (f.user2_id = u.id AND f.user2_id != ?)
     WHERE (f.user1_id = ? OR f.user2_id = ?) AND f.status = 'active'
     ORDER BY f.date_connected DESC;
     ```

4. **View Friend Activity** (HomeView - Activity Feed)
   - **Frontend Action**: User views activity feed of friends
   - **SQL Query**:
     ```sql
     SELECT a.id, a.activity_type, a.created_at, a.activity_metadata,
            u.id as user_id, u.username, u.display_name, u.avatar_url,
            b.id as book_id, b.title, b.cover_image_url
     FROM activities a
     JOIN users u ON a.user_id = u.id
     LEFT JOIN books b ON a.target_book_id = b.id
     WHERE a.user_id IN (
         SELECT CASE WHEN user1_id = ? THEN user2_id ELSE user1_id END
         FROM friends
         WHERE (user1_id = ? OR user2_id = ?) AND status = 'active'
     )
     AND a.visibility IN ('public', 'friends_only')
     ORDER BY a.created_at DESC
     LIMIT 50;
     ```

---

## 7. Badge and Achievement Tables

### `badges` Table
**Purpose**: Badge definitions with unlock criteria.

**Key Attributes**:
- `id`: Primary key
- `name`: Badge name (unique)
- `description`: Badge description
- `category`: Reading, Collection, Social, or Discovery
- `tier`: Bronze, Silver, Gold, Platinum, or Diamond
- `unlock_criteria`: JSON field with criteria

### `user_badges` Table
**Purpose**: Badges earned by users.

**Key Attributes**:
- `id`: Primary key
- `user_id`, `badge_id`: Foreign keys (unique constraint)
- `date_earned`: When badge was earned
- `progress_to_next_tier`: Progress percentage

**User Interactions**:

1. **Check Badge Eligibility** (Background process after reading activity)
   - **Frontend Action**: System automatically checks after user completes reading action
   - **SQL Queries**:
     ```sql
     -- Example: Check if user earned "First Book" badge
     SELECT COUNT(*) as books_read
     FROM user_books
     WHERE user_id = ? AND reading_status = 'Read';
     
     -- If count = 1, award badge
     INSERT INTO user_badges (user_id, badge_id, date_earned)
     SELECT ?, id, CURDATE()
     FROM badges
     WHERE name = 'First Book'
     AND NOT EXISTS (
         SELECT 1 FROM user_badges 
         WHERE user_id = ? AND badge_id = badges.id
     );
     
     -- Create activity
     INSERT INTO activities (user_id, activity_type, target_badge_id, visibility)
     VALUES (?, 'earned_badge', LAST_INSERT_ID(), 'public');
     ```

2. **View User Badges** (ProfileView - Badges section)
   - **Frontend Action**: User views their earned badges
   - **SQL Query**:
     ```sql
     SELECT ub.id, ub.date_earned, ub.progress_to_next_tier,
            b.id as badge_id, b.name, b.description, b.category, b.tier, b.icon_url
     FROM user_badges ub
     JOIN badges b ON ub.badge_id = b.id
     WHERE ub.user_id = ?
     ORDER BY ub.date_earned DESC;
     ```

---

## 8. Activity Feed Table

### `activities` Table
**Purpose**: Activity feed entries for social features.

**Key Attributes**:
- `id`: Primary key
- `user_id`: Foreign key to users
- `activity_type`: Type of activity (added_book, finished_reading, wrote_review, earned_badge)
- `target_book_id`, `target_review_id`, `target_badge_id`: Polymorphic foreign keys
- `activity_metadata`: JSON field for additional data
- `visibility`: Public, private, or friends_only

**User Interactions**:

1. **View Activity Feed** (HomeView)
   - **Frontend Action**: User views their home feed
   - **SQL Query**:
     ```sql
     SELECT a.id, a.activity_type, a.created_at, a.activity_metadata,
            u.id as user_id, u.username, u.display_name, u.avatar_url,
            b.id as book_id, b.title, b.cover_image_url,
            r.id as review_id, r.rating,
            bg.id as badge_id, bg.name as badge_name, bg.icon_url
     FROM activities a
     JOIN users u ON a.user_id = u.id
     LEFT JOIN books b ON a.target_book_id = b.id
     LEFT JOIN reviews r ON a.target_review_id = r.id
     LEFT JOIN badges bg ON a.target_badge_id = bg.id
     WHERE a.user_id = ? OR a.visibility = 'public' OR 
           (a.visibility = 'friends_only' AND EXISTS (
               SELECT 1 FROM friends 
               WHERE ((user1_id = ? AND user2_id = a.user_id) OR 
                      (user2_id = ? AND user1_id = a.user_id))
               AND status = 'active'
           ))
     ORDER BY a.created_at DESC
     LIMIT 50;
     ```

---

## 9. Notification Table

### `notifications` Table
**Purpose**: User notifications for social interactions.

**Key Attributes**:
- `id`: Primary key
- `recipient_id`: Foreign key to users
- `notification_type`: Type (friend_request, review_comment, activity_mention, badge_earned)
- `associated_friend_request_id`, `associated_review_id`: Optional foreign keys
- `notification_content`: Notification message
- `is_read`: Read status
- `read_at`: When notification was read

**User Interactions**:

1. **View Notifications** (ProfileView - Notifications tab)
   - **Frontend Action**: User opens notifications panel
   - **SQL Query**:
     ```sql
     SELECT id, notification_type, notification_content, is_read, created_at,
            associated_friend_request_id, associated_review_id
     FROM notifications
     WHERE recipient_id = ?
     ORDER BY is_read ASC, created_at DESC
     LIMIT 50;
     ```

2. **Mark Notification as Read** (ProfileView - Tap notification)
   - **Frontend Action**: User taps on a notification
   - **SQL Query**:
     ```sql
     UPDATE notifications 
     SET is_read = TRUE, read_at = NOW()
     WHERE id = ? AND recipient_id = ?;
     ```

---

## Query Grouping by Interface Type

### Authentication Interface (LoginView, SignUpView)
- User registration/login queries
- Profile retrieval queries
- Session management queries

### Book Discovery Interface (ExploreView, ScanView)
- Book search queries
- ISBN lookup queries
- Book detail queries
- Author and genre queries

### Library Management Interface (LibraryView)
- User book collection queries
- Reading status updates
- Reading session logging
- Progress tracking queries
- Statistics queries

### Shelf Organization Interface (LibraryView - Shelf section)
- Shelf CRUD operations
- Book-to-shelf assignment queries
- Shelf display queries
- Reordering queries

### Review Interface (ReviewWriteView, BookDetailView)
- Review creation/update queries
- Review display queries
- Rating queries

### Social Interface (HomeView, ProfileView)
- Friend request queries
- Friend list queries
- Activity feed queries
- Notification queries

### Profile Interface (ProfileView)
- User profile queries
- Badge display queries
- Statistics queries
- Friend list queries

---

## Summary

This database schema supports a comprehensive book tracking and social reading application. The 18 tables are organized into logical groups that map directly to frontend interfaces:

- **Core tables** (users, books, authors, genres) provide the foundation
- **User-book relationships** (user_books, reading_sessions, reading_history) track reading activity
- **Organization tables** (shelves, shelf_books) enable custom book organization
- **Social tables** (reviews, friends, friend_requests, activities, notifications) power social features
- **Achievement tables** (badges, user_badges) gamify the reading experience

Each frontend action triggers specific SQL queries that maintain data integrity through foreign key constraints and ensure optimal performance through strategic indexing.

