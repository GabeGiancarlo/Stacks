# Stacks API Documentation

REST API documentation for the Stacks backend.

**Base URL**: `http://localhost:8080` (development)

All endpoints return JSON. Dates are in ISO 8601 format.

## Authentication

Most endpoints require authentication via JWT Bearer token in the Authorization header:

```
Authorization: Bearer <access_token>
```

### POST /api/auth/signup

Create a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "username": "johndoe"
}
```

**Response:** `201 Created`
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "johndoe"
  }
}
```

**Errors:**
- `400`: Missing required fields
- `409`: Email already registered

---

### POST /api/auth/login

Authenticate and receive tokens.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response:** `200 OK`
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "johndoe"
  }
}
```

**Errors:**
- `401`: Invalid email or password

---

### POST /api/auth/refresh

Refresh access token using refresh token.

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:** `200 OK`
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Errors:**
- `401`: Invalid or expired refresh token

---

### POST /api/auth/logout

Logout (client-side token removal recommended).

**Response:** `200 OK`
```json
{
  "message": "Logged out successfully"
}
```

---

## Books

### GET /api/books

Get user's library (requires auth).

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "isbn": "9780593099322",
    "title": "Dune",
    "author": "Frank Herbert",
    "coverUrl": "/uploads/cover.jpg",
    "description": "Set on the desert planet Arrakis...",
    "publishedYear": 1965,
    "status": "read",
    "addedAt": "2024-01-15T10:30:00.000Z"
  }
]
```

---

### POST /api/books

Add book to library (requires auth).

**Request:** `multipart/form-data` or `application/json`

**Form Fields:**
- `title` (required): Book title
- `author` (required): Author name
- `isbn` (optional): ISBN code
- `description` (optional): Book description
- `publishedYear` (optional): Publication year
- `cover` (optional): Cover image file

**Response:** `201 Created`
```json
{
  "id": 1,
  "isbn": "9780593099322",
  "title": "Dune",
  "author": "Frank Herbert",
  "coverUrl": "/uploads/cover.jpg",
  "status": "want_to_read",
  "addedAt": "2024-01-15T10:30:00.000Z"
}
```

**Errors:**
- `400`: Missing required fields
- `409`: Book already in library

---

### GET /api/books/:id

Get book details with reviews (requires auth).

**Response:** `200 OK`
```json
{
  "id": 1,
  "isbn": "9780593099322",
  "title": "Dune",
  "author": "Frank Herbert",
  "coverUrl": "/uploads/cover.jpg",
  "description": "Set on the desert planet Arrakis...",
  "publishedYear": 1965,
  "status": "read",
  "reviews": [
    {
      "id": 1,
      "userId": 1,
      "username": "johndoe",
      "bookId": 1,
      "rating": 5,
      "reviewText": "Amazing book!",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

**Errors:**
- `404`: Book not found

---

### PUT /api/books/:id

Update book (requires auth, must own the book).

**Request:** `multipart/form-data` or `application/json`

**Form Fields:** Same as POST /api/books

**Response:** `200 OK` (same as GET /api/books/:id)

**Errors:**
- `403`: Book not in your library
- `404`: Book not found

---

### DELETE /api/books/:id

Remove book from library (requires auth).

**Response:** `200 OK`
```json
{
  "message": "Book removed from library"
}
```

**Errors:**
- `404`: Book not in library

---

## Reviews

### POST /api/books/:bookId/reviews

Create review (requires auth, must own the book).

**Request Body:**
```json
{
  "rating": 5,
  "reviewText": "Amazing book! Highly recommend."
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "userId": 1,
  "bookId": 1,
  "rating": 5,
  "reviewText": "Amazing book! Highly recommend.",
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

**Errors:**
- `400`: Invalid rating (must be 1-5)
- `403`: Book not in your library
- `409`: Review already exists

---

### PUT /api/reviews/:id

Update review (requires auth, must own the review).

**Request Body:**
```json
{
  "rating": 4,
  "reviewText": "Updated review text"
}
```

**Response:** `200 OK` (same as POST)

**Errors:**
- `403`: Not authorized
- `404`: Review not found

---

### DELETE /api/reviews/:id

Delete review (requires auth, must own the review).

**Response:** `200 OK`
```json
{
  "message": "Review deleted successfully"
}
```

**Errors:**
- `403`: Not authorized
- `404`: Review not found

---

## Explore

### GET /api/explore/recommendations

Get book recommendations (requires auth).

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "isbn": "9780593099322",
    "title": "Dune",
    "author": "Frank Herbert",
    "coverUrl": "/uploads/cover.jpg",
    "description": "...",
    "publishedYear": 1965
  }
]
```

---

## Profile

### GET /api/users/me

Get current user profile with stats (requires auth).

**Response:** `200 OK`
```json
{
  "id": 1,
  "email": "user@example.com",
  "username": "johndoe",
  "createdAt": "2024-01-01T00:00:00.000Z",
  "stats": {
    "totalBooks": 10,
    "booksRead": 5,
    "reviewsWritten": 3,
    "readingStreak": 7
  }
}
```

---

### GET /api/users/me/badges

Get user's earned badges (requires auth).

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "name": "First Book",
    "tier": "bronze",
    "iconUrl": null,
    "criteria": "Add your first book to the library",
    "earnedAt": "2024-01-15T10:30:00.000Z"
  }
]
```

---

## Error Responses

All errors follow this format:

```json
{
  "error": "Error message description"
}
```

**Status Codes:**
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `409`: Conflict
- `500`: Internal Server Error

---

## Rate Limiting

Auth endpoints are rate-limited:
- **Limit**: 100 requests per 15 minutes per IP
- **Response**: `429 Too Many Requests` with error message

---

## Token Expiration

- **Access Token**: 15 minutes
- **Refresh Token**: 7 days

When access token expires (401), use refresh token to get a new access token.

---

## Health Check

### GET /health

Check API health status.

**Response:** `200 OK`
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

