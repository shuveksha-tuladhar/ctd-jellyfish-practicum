#!/bin/bash
set -e

# Reset and migrate database
bundle exec rails db:reset db:migrate

# Then exec the container CMD
exec "$@"
