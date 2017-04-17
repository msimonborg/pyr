# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pyr/version'

Gem::Specification.new do |spec|
  spec.name          = 'pyr'
  spec.version       = PYR::VERSION
  spec.authors       = ['M. Simon Borg']
  spec.email         = ['msimonborg@gmail.com']

  spec.summary       = 'Make requests to the Phone Your Rep API and get '\
    'Ruby objects in return'
  spec.description   = 'Wraps the Phone Your Rep API up with an idiomatic Ruby'\
    ' bow. Easily construct requests with block syntax and receive a response '\
    'with http status, headers, raw body, and ActiveRecord-esque objects that '\
    'make data-querying easy (using the lazy_record gem).'
  spec.homepage      = 'https://www.github.com/msimonborg/pyr'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|doc)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'
  spec.add_dependency 'faraday', '~> 0.12.0'
  spec.add_dependency 'faraday_middleware', '~> 0.11.0'
  spec.add_dependency 'lazy_record', '~> 0.4.0'
  spec.add_development_dependency 'bundler', '~> 1.14'
end
