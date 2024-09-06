source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "pretender", "~> 0.2.gem"
gem "view_component"
gem "text_helpers"

group :development, :test do
  gem "pg"
  gem "puma"
  gem "pry-rails"
  gem "spring"
  gem "standard", "=1.24.3" # Changes to this may change our linting rules; locking it to ensure updates are intentional.
  gem "standardrb", require: false
  gem "dotenv"
end

group :test do
  gem "capybara"
  gem "spring-commands-rspec"
  gem "faker"
end
