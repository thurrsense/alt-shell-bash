#!/bin/bash

# Function to print help message
print_help() {
  echo "Usage: backup.sh [options] <source_directory> <destination_directory>"
  echo "Options:"
  echo "  --help  Show this help message"
}

# Parse command line options
key="$1"

# Check if source directory is provided
if [ -z "$1" ]
then
  echo "Source directory not provided"
  print_help
  exit 1
fi

# Check if destination directory is provided
if [ -z "$2" ]
then
  echo "Destination directory not provided"
  print_help
  exit 1
fi

# Check if source directory exists
if [ ! -d "$1" ]
then
  echo "Source directory does not exist"
  exit 1
fi

# Check if destination directory exists, create if not
if [ ! -d "$2" ]
then
  mkdir -p "$2"
fi

# Create backup directory with timestamp including milliseconds
timestamp=$(date +%Y-%m-%d_%H-%M-%S.%3N)
backup_dir="$2/backup_$timestamp"
mkdir -p "$backup_dir"

# Copy files from source directory to backup directory
cp -r "$1"/* "$backup_dir"

# Delete oldest backup directory if more than 10 directories exist
num_backups=$(ls -1 "$2" | grep "backup_*" | wc -l)
if [ "$num_backups" -gt 10 ]
then
  oldest_backup=$(ls -1t "$2" | grep "backup_*" | tail -1)
  rm -rf "$2/$oldest_backup"
fi
