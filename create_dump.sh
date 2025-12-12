#!/bin/bash

# Script to create a SQL dump of the Stacks database
# This script exports the complete database schema and data

echo "Creating SQL dump of stacks_db database..."

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check if MySQL container is running
if ! docker ps | grep -q stacks_mysql; then
    echo "Error: MySQL container (stacks_mysql) is not running."
    echo "Please start the database with: docker-compose up -d"
    exit 1
fi

# Create the dump
OUTPUT_FILE="database_dump.sql"

echo "Exporting database to $OUTPUT_FILE..."

docker exec stacks_mysql mysqldump \
    -u stacks_user \
    -psecure_password \
    --no-tablespaces \
    --routines \
    --triggers \
    stacks_db > "$OUTPUT_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Database dump created successfully: $OUTPUT_FILE"
    echo "  File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
else
    echo "✗ Error creating database dump"
    exit 1
fi

