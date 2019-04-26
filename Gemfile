source 'https://rubygems.org'

# Specify your gem's dependencies in huzzah.gemspec
gemspec

local_gemfile = File.expand_path('Gemfile.local', __dir__)
eval_gemfile local_gemfile if File.exist?(local_gemfile)
