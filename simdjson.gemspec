lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simdjson/version'

Gem::Specification.new do |spec|
  spec.name          = 'simdjson'
  spec.version       = Simdjson::VERSION
  spec.authors       = ['saka1']
  spec.email         = ['github@saka1.net']

  spec.summary       = 'Ruby binding to simdjson.'
  spec.description   = "simdjson gem is a binding to use simdjson, which is a Lemire's fast JSON parser."
  spec.homepage      = 'https://github.com/saka1/simdjson_ruby'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # TODO: remove unnecessary files
  spec.files        += Dir.glob('vendor/simdjson/**/*').delete_if { |f| f =~ /json$/ }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions    = ['ext/simdjson/extconf.rb']

  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
end
