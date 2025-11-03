# Database Assignment - Stacks Application

This folder contains the Entity-Relationship (ER) Diagram and MySQL database schema for the Stacks application.

## Contents

1. **ER-Diagram.md** - Complete ER Diagram using Mermaid syntax
   - Shows all entities and their relationships
   - Includes relationship cardinalities
   - Documents foreign key relationships

2. **schema.sql** - MySQL database schema implementation
   - All tables with proper data types
   - Primary keys (auto-incrementing IDs)
   - Foreign keys matching the ER diagram relationships
   - Indexes for performance optimization
   - Unique constraints
   - Check constraints for data validation

## ER Diagram Overview

The ER Diagram defines 18 entities organized into:
- **Core Entities**: users, books, authors, genres
- **User-Book Relationships**: user_books, reading_sessions, reading_history
- **Organization & Shelves**: shelves, shelf_books
- **Social Features**: reviews, friends, friend_requests, activities
- **Badges & Achievements**: badges, user_badges
- **Supporting Entities**: book_authors, book_genres, notifications

## Schema Implementation

The SQL schema includes:
- All 18 tables matching the ER diagram entities
- Proper foreign key constraints with CASCADE and SET NULL behaviors
- Unique constraints (ISBN, email, username, one review per user per book)
- Indexes on frequently queried columns
- Appropriate data types for each field
- Timestamps for created_at and updated_at fields
- ENUM types for status fields

## Foreign Key Relationships

All foreign keys from the ER diagram are implemented in the schema:

1. **user_books**: `user_id` → `users.id`, `book_id` → `books.id`
2. **reading_sessions**: `user_book_id` → `user_books.id`
3. **reading_history**: `user_id` → `users.id`
4. **shelves**: `user_id` → `users.id`
5. **shelf_books**: `shelf_id` → `shelves.id`, `book_id` → `books.id`
6. **reviews**: `user_id` → `users.id`, `book_id` → `books.id`
7. **friends**: `user1_id` → `users.id`, `user2_id` → `users.id`
8. **friend_requests**: `requester_id` → `users.id`, `recipient_id` → `users.id`
9. **activities**: `user_id` → `users.id`, `target_book_id` → `books.id`, `target_review_id` → `reviews.id`, `target_badge_id` → `badges.id`
10. **user_badges**: `user_id` → `users.id`, `badge_id` → `badges.id`
11. **book_authors**: `book_id` → `books.id`, `author_id` → `authors.id`
12. **book_genres**: `book_id` → `books.id`, `genre_id` → `genres.id`
13. **notifications**: `recipient_id` → `users.id`, `associated_friend_request_id` → `friend_requests.id`, `associated_review_id` → `reviews.id`
14. **genres**: `parent_genre_id` → `genres.id` (self-referential for hierarchy)

## Usage

To create the database:

```bash
mysql -u root -p < schema.sql
```

Or connect to MySQL and source the file:

```sql
source schema.sql;
```

## Verification

The schema has been verified to:
- ✅ Match all relationships defined in the ER diagram
- ✅ Include all foreign keys with proper referential integrity
- ✅ Include appropriate indexes for query performance
- ✅ Include unique constraints where specified
- ✅ Follow MySQL best practices for data types and constraints

