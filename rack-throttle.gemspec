#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rack-throttle'
  gem.homepage           = 'https://github.com/bendiken/rack-throttle'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'HTTP request rate limiter for Rack applications.'
  gem.description        = 'Rack middleware for rate-limiting incoming HTTP requests.'

  gem.authors            = ['Arto Bendiken']
  gem.email              = 'arto@bendiken.net'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 2.0.0'
  gem.requirements               = []
  gem.add_development_dependency 'rack-test', '0.6.3'
  gem.add_development_dependency 'rspec',     '3.3.0'
  gem.add_development_dependency 'timecop',   '0.3.4'
  gem.add_development_dependency 'yard' ,     '>= 0.5.5'
  gem.add_runtime_dependency     'rack',      '>= 1.0.0'
  gem.post_install_message       = nil
end
