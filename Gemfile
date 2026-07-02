redmine_gemfile = File.expand_path('../../Gemfile', File.dirname(__FILE__))
request_store_in_redmine = File.exist?(redmine_gemfile) &&
  File.read(redmine_gemfile).match?(/gem\s+['"]request_store['"]/)

gem 'request_store' unless request_store_in_redmine