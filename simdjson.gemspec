# frozen_string_literal: true

version = File.read(File.expand_path('lib/simdjson/version.rb', __dir__))[/VERSION = '(.*)'/, 1]

Gem::Specification.new do |spec|
  spec.name          = 'simdjson'
  spec.version       = version
  spec.authors       = ['saka1']
  spec.email         = ['github@saka1.net']

  spec.summary       = 'Ruby binding to simdjson.'
  spec.description   = 'Ruby binding for simdjson, a fast JSON parser.'
  spec.homepage      = 'https://github.com/saka1/simdjson_ruby'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.2'

  spec.files = Dir.glob(%w[
                          lib/**/*.rb
                          ext/simdjson/extconf.rb
                          ext/simdjson/simdjson_ruby.cpp
                          ext/simdjson/simdjson.h
                          ext/simdjson/simdjson.cpp
                          LICENSE.txt
                          README.md
                        ])
  spec.require_paths = ['lib']
  spec.extensions    = ['ext/simdjson/extconf.rb']

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true'
  }
end
