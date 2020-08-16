# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'rake/extensiontask'

require 'fileutils'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

SIMDJSON_SINGLEHEADER_DIR = File.join(__dir__, 'vendor', 'simdjson', 'singleheader')
task compile: :before_compile
task :before_compile do
  puts 'Copy singleheader files to ext/simdjson...'
  FileUtils.cp([
                 "#{SIMDJSON_SINGLEHEADER_DIR}/simdjson.h",
                 "#{SIMDJSON_SINGLEHEADER_DIR}//simdjson.cpp"
               ],
               'ext/simdjson')
end

Rake::ExtensionTask.new('simdjson') do |ext|
  ext.lib_dir = 'lib/simdjson'
end

task :bench do
  ruby('benchmark/run_benchmark.rb')
end

task default: %i[clobber compile test]
