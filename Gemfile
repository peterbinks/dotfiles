source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "pretender", "~> 0.2.gem"
gem "view_component"
gem "vite_rails"
gem "text_helpers"
gem "devise"
gem "feature", "~> 1.4.0"

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
  gem "rspec-rails", ">= 4.0"
  gem "spring-commands-rspec"
  gem "rails-controller-testing"
  gem "faker"
  gem "psych", "< 3.3.0" # higher versions of psych break yaml alias usage in i18n
end
