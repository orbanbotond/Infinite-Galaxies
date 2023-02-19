source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'aggregate_root', '~> 2.5.1'
gem 'ruby_event_store', '~> 2.5.1'
gem 'dry-types'
gem 'dry-struct'
gem 'infra', path: './infra'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec'
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'rspec'
end
