#!/bin/bash
# Setup environment file for dev container

ENV_FILE="/workspace/reporting-app/.env"
ENV_EXAMPLE="/workspace/reporting-app/local.env.example"

# Create .env from example if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    echo "📝 Creating .env file from example..."
    cp "$ENV_EXAMPLE" "$ENV_FILE"
fi

# Update DB_HOST for container environment
echo "🔧 Configuring database host for container..."
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=reporting-app-database/g' "$ENV_FILE" 2>/dev/null || \
sed -i '' 's/DB_HOST=127.0.0.1/DB_HOST=reporting-app-database/g' "$ENV_FILE"

echo "✅ Environment file configured for dev container"


