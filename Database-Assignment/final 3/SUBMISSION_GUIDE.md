# Final Assignment 3 - Submission Guide

This folder contains all files required for the final database assignment submission.

## Files Included

1. **DATABASE_DOCUMENTATION.md** - Complete documentation explaining:
   - All 18 database tables and their purposes
   - How users interact with each table through the frontend
   - Example SQL queries triggered by frontend actions
   - Query grouping by interface type

2. **sample_data.sql** - Sample data file with at least 3 rows per table for testing

3. **schema.sql** - (Located in parent directory) The complete database schema with all tables, constraints, and foreign keys

4. **ER-Diagram.md** - (Located in ../ER Diagrams/) The Entity-Relationship diagram

## Generating the Database Dump

To create the database dump file required for submission:

### Step 1: Create the Database
```bash
mysql -u root -p < ../schema.sql
```

### Step 2: Load Sample Data (Optional but recommended)
```bash
mysql -u root -p stacks_db < sample_data.sql
```

### Step 3: Generate the Database Dump
Navigate to this folder in your terminal and run:

```bash
mysqldump -u root -p stacks_db > stacks_db_dump.sql
```

This will create a file called `stacks_db_dump.sql` containing:
- All table structures
- All constraints (primary keys, foreign keys, unique constraints, check constraints)
- All indexes
- All sample data (if you loaded sample_data.sql)

## Verification

After generating the dump, verify it contains data:

```bash
# Check the dump file size (should be > 0)
ls -lh stacks_db_dump.sql

# View first few lines to confirm structure
head -50 stacks_db_dump.sql
```

## What to Submit

Submit the following files:

1. ✅ **stacks_db_dump.sql** - The complete database dump (generate using instructions above)
2. ✅ **DATABASE_DOCUMENTATION.md** - The documentation file (already created)
3. ✅ **schema.sql** - The schema file (from parent directory)
4. ✅ **ER-Diagram.md** - The ER diagram (from ../ER Diagrams/)

## Database Name

The database name is: **stacks_db**

If you need to verify this, connect to MySQL and run:
```sql
SHOW DATABASES;
```

## Notes

- The schema includes 18 tables with proper foreign key relationships
- All foreign keys have appropriate CASCADE and SET NULL behaviors
- Unique constraints are in place for ISBN, email, username, and one-review-per-user-per-book
- Sample data includes realistic relationships between entities
- The documentation maps every frontend action to specific SQL queries

