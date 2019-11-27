source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.4'

gem 'pg', '~> 1.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.0'

# DRY gemsets https://dry-rb.org/
gem 'dry-validation', '~> 0.13.0'

gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'pry', '~> 0.12.2'
  gem 'pry-byebug', '~> 3.7.0'
end

group :test do
  gem 'rspec-rails', '~> 3.9.0'

  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'faker', '~> 2.7.0'

  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
