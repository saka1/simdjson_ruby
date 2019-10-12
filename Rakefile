require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

require 'rake/extensiontask'

gemspec = Gem::Specification.load(File.expand_path('simdjson.gemspec', __dir__))
Rake::ExtensionTask.new('simdjson', gemspec) do |ext|
  ext.lib_dir = 'lib/simdjson'
end

task :bench do
  ruby('benchmark/run_benchmark.rb')
end

task :clean_vendor do
  Dir.chdir('vendor/simdjson') do
    `git clean -fd`
    `git checkout .`
  end
end

task default: %i[clobber compile test clean_vendor]
