# Dev Container Setup

This directory contains the **Cursor IDE** optimized configuration for running the Community Engagement Medicaid Reporting App in a remote container using Docker Desktop.

## Quick Start

1. **Prerequisites:**

   - **Docker Desktop** installed and running
   - **Cursor IDE** (latest version recommended)
   - Dev Containers support enabled in Cursor

2. **Open in Container:**

   - Open this project in Cursor IDE
   - Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
   - Type and select **"Dev Containers: Reopen in Container"**
   - Wait for the container to build and start (first time may take 5-10 minutes)

3. **Automatic Setup:**
   - ✅ Gems installed via `bundle install`
   - ✅ NPM packages installed via `npm install`
   - ✅ Database created and migrated
   - ✅ Rails server ready on port 3000
   - ✅ PostgreSQL available on port 5432

### First Time Setup (After Container Build)

After the container builds, compile the assets:

```bash
cd reporting-app
npm run build:css
```

This compiles Sass stylesheets into `app/assets/builds/application.css`. **Required before first run.**

## Configuration

### Files

- **`devcontainer.json`** - Main dev container configuration (2025 optimized for Cursor)
- **`docker-compose.override.yml`** - Docker Compose overrides for development
- **`README.md`** - This file

### Key 2025 Updates

#### Ruby LSP (Shopify)

- **Using:** `shopify.ruby-lsp` - Modern Ruby language server with better performance

#### Extensions

- GitLens for advanced Git features
- Error Lens for inline diagnostics
- Code Spell Checker
- PostgreSQL tools for database management
- Enhanced Rails snippets and utilities

### Services

- **reporting-app**: Rails 7+ application (Ruby 3.4.6)
- **reporting-app-database**: PostgreSQL 14

### Ports

- **3000**: Rails application (auto-forwarded with notification)
- **5432**: PostgreSQL database (auto-forwarded silently)

### Volumes

- `reporting-app_nodemodules`: Node.js dependencies
- `reporting-app_tmp`: Temporary files
- `reporting-app_storage`: File storage
- `reporting-app_log`: Application logs

## Project Structure in Container

The **entire project root** is synced to the container:

```
/workspace/                          ← Your local project root (FULL SYNC)
├── .devcontainer/                   ← Dev container configuration
├── bin/                             ← Project scripts
├── docs/                            ← All documentation
├── e2e/                             ← E2E tests
├── infra/                           ← Infrastructure code (Terraform)
├── reporting-app/                   ← Rails application
│   ├── app/
│   ├── config/
│   ├── db/
│   └── ... (all Rails files)
└── Makefile
```

- ✅ Edit ANY file in the project (docs, infra, e2e, Rails app)
- ✅ All changes sync instantly between local and container

### Starting the Application

Use the terminal in the VsCode IDE. This terminal will automatically open in the container.

```bash
# Navigate to Rails app directory
cd reporting-app

# Start Rails server
bundle exec rails server

# Or use the Rails dev server (with asset watching)
./bin/dev
```

### Running Tests

```bash
# Navigate to Rails app first
cd reporting-app

# Run all specs
bundle exec rspec

# Run specific spec file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Database Operations

The dev and test databases will automatically be created during container initialization.

```bash
# Navigate to Rails app first
cd reporting-app

# Access database console
bundle exec rails dbconsole
# Or use psql directly:
psql -h reporting-app-database -U app -d app
```

### Code Quality

```bash
# Navigate to Rails app first
cd reporting-app

# Run RuboCop
bundle exec rubocop

# Auto-fix RuboCop issues
bundle exec rubocop -A

# Run security checks
bundle exec brakeman
```

### Working with Other Project Components

````bash
# From /workspace root, you can access:

# Infrastructure code
cd infra
terraform init
terraform plan

# E2E tests
cd e2e
npm install
npm test


## Troubleshooting

### Container Won't Start

```bash
# 1. Ensure Docker Desktop is running
# 2. Check if ports are available
lsof -i :3000
lsof -i :5432

# 3. Rebuild the container
# Command Palette (Cmd/Ctrl+Shift+P) → "Dev Containers: Rebuild Container"

# 4. Clean rebuild (if issues persist)
docker-compose -f reporting-app/docker-compose.yml down -v
# Then reopen in container
````

### Database Connection Issues

```bash
# Check database container health
docker ps

# Check database logs
docker logs reporting-app-database

# Test connection manually
psql -h reporting-app-database -U app -d app -c "SELECT 1;"
```

### Slow Performance

```bash
# Check Docker Desktop resources (increase if needed)
# Recommended: 4+ CPU cores, 8+ GB RAM

# Clear cache and rebuild
bundle clean --force
bundle install
npm ci
```

## Environment Variables

Container **auto-configures** during initialization:

- ✅ Creates `.env` from `local.env.example` (if not exists)
- ✅ Sets `DB_HOST=reporting-app-database`
- ✅ Sets `DB_PORT=5432`
- ✅ Sets `DB_NAME=app`
- ✅ Sets `DB_USER=app`
- ✅ Sets `DB_PASSWORD=secret123`
- ✅ Sets `RAILS_ENV=development`

**Optional:** Edit `reporting-app/.env` for custom overrides (AWS keys, COGNITO settings, etc.)

- `DB_HOST=reporting-app-database` ✅ Auto-set
- `DB_PORT=5432` ✅ Auto-set
- `DB_NAME=app` ✅ Auto-set
- `DB_USER=app` ✅ Auto-set
- `DB_PASSWORD=secret123` ✅ Auto-set
- `RAILS_ENV=development` ✅ Auto-set
- `AUTH_ADAPTER=mock` ⚙️ Set in `.env` for local development
