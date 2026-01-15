# SaveData AI Agent Instructions

## Project Overview
SaveData is a Rails 7.2 application that records gaming history through an age × timeline axis. Users register their birth date and games played at different life stages, enabling reflection on personal gaming experiences and discovering generational patterns.

**Tech Stack**: Ruby on Rails 7.2, PostgreSQL, Stimulus.js, Tailwind CSS, Docker, Devise authentication

---

## Architecture & Data Model

### Core Domain
- **User Model** ([app/models/user.rb](app/models/user.rb)): Central entity with Devise integration
  - Required fields: `email`, `name`, `birthday`, `gender`
  - Devise modules: registerable, database_authenticatable, recoverable, rememberable
  - Timeline analysis depends on accurate `birthday` data for age calculations
  
- **Key Gem**: `groupdate` for age × timeline aggregation (future feature for game records)
  
### Authentication
- Devise-based auth with standard passwordless recovery
- Config at [config/initializers/devise.rb](config/initializers/devise.rb)
- Routes: `/users/sign_up`, `/users/sign_in` (Devise-managed)
- `authenticate_user!` required on protected controllers

### Development vs Production
- **Dev Database**: PostgreSQL in Docker (compose.yml), runs with `./bin/dev`
- **Production**: Kamal deployment ready, RAILS_MASTER_KEY required

---

## Development Workflow

### Local Setup
```bash
docker compose up -d           # Start PostgreSQL
./bin/dev                      # Run Rails + JS/CSS watchers simultaneously
rails db:migrate               # Apply pending migrations
```

### Key Commands
| Task | Command |
|------|---------|
| Run tests | `rails test` (uses parallel workers) |
| Security audit | `brakeman` |
| Style/lint | `rubocop-rails-omakase` |
| Generate model | `rails g model ModelName --migration --test` |
| DB reset | `rails db:drop db:create db:migrate` |

### Asset Building
- **CSS**: `yarn build:css --watch` compiles Tailwind CSS to `app/assets/builds/application.css`
- **JS**: `yarn build --watch` bundles with esbuild to `app/assets/builds/application.js`
- Procfile.dev orchestrates watchers via `./bin/dev`

---

## Code Patterns & Conventions

### Controllers
- Inherit from `ApplicationController` which enforces `authenticate_user!` via before_action
- Standard Rails RESTful structure (index, show, new, create, edit, update, destroy)
- Use `before_action :set_user` for single-resource lookups
- Example: [app/controllers/users_controller.rb](app/controllers/users_controller.rb) shows full CRUD + JSON responses

### Models
- Place business logic in models, not controllers
- Use `validates` for presence/uniqueness checks in User model
- Models auto-annotated with schema info (see schema comments in [app/models/user.rb](app/models/user.rb))

### Views
- Standard ERB templates in `app/views/[resource]/`
- Styled with Tailwind utility classes
- No custom CSS—extend Tailwind config if needed
- Stimulus controllers in [app/javascript/controllers/](app/javascript/controllers/) for interactivity

### Testing
- Unit tests: `test/models/user_test.rb`
- Controller tests: `test/controllers/users_controller_test.rb`
- System tests: `test/system/users_test.rb` (Capybara + Selenium)
- Test fixtures in `test/fixtures/users.yml`
- Use FactoryBot + Faker for dynamic test data in specs

---

## Critical Patterns

### Database Migrations
- Files in `db/migrate/` with timestamp prefix (e.g., `20260115102433_add_devise_to_users.rb`)
- **Always create migration** before modifying schema; never edit schema.rb directly
- Run: `rails db:migrate` or `rails db:rollback` to undo

### Devise Integration
- User authentication via Devise; don't override core behavior unless necessary
- Custom validations on User model work alongside Devise modules
- Password reset uses Devise's built-in token + mailer (configured in config/initializers/devise.rb)

### Future Timeline Feature
- `groupdate` gem is installed but not yet active—will aggregate game records by user age
- Reserve `@games` or similar collection on User for game relationships (to be added)

---

## Project-Specific Guidelines

### When Adding Features
1. **Games Feature** (upcoming): Create `Game` model with `user_id`, `title`, `release_year`, `played_at_age`
2. **Validations**: Keep Japanese error messages in locale files ([config/locales/en.yml](config/locales/en.yml))
3. **Admin Panel**: Rails Admin is installed; models auto-exposed in `/admin` (config: [config/initializers/rails_admin.rb](config/initializers/rails_admin.rb))
4. **Emails**: Use `ApplicationMailer` base class; test with `Mail::TestMailer` in test suite

### Debugging
- **Logs**: Check `log/development.log` for request details
- **Interactive console**: `rails console` to query models directly
- **Breakpoints**: Use `binding.pry` (requires pry gem) or Ruby 3.2's `debugger`
- **Docker execution**: `docker compose exec web rails [command]`

### Security Considerations
- Run `brakeman` before commits to catch common Rails vulnerabilities
- User passwords encrypted by Devise; never log or expose
- `credentials.yml.enc` stores secrets (edit: `rails credentials:edit`)

---

## File Structure Reference
```
app/
  models/user.rb          ← Core model, Devise config
  controllers/            ← RESTful controller logic
  views/                  ← ERB templates + Tailwind styling
  javascript/controllers/ ← Stimulus.js interactivity
config/
  routes.rb               ← Root → users#index, Devise routes
  initializers/           ← devise.rb, rails_admin.rb (key configs)
  environments/           ← dev/test/prod differences
db/
  migrate/                ← Versioned schema changes
  schema.rb               ← Current schema (auto-generated)
test/                     ← Unit, controller, system tests
```

---

## Questions to Ask Yourself
- **Does a route exist for this feature?** Check [config/routes.rb](config/routes.rb)
- **Is the model validated?** User model shows the pattern—validate required fields
- **Should UI be interactive?** Use Stimulus controllers, not inline JavaScript
- **Need a database change?** Always write a migration, never edit schema.rb
- **Is this secured?** Verify `authenticate_user!` guards the controller action
