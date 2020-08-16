#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark/ips'
require 'json'
require 'simdjson'
require 'oj'

files = %w[
  apache_builds.json
  github_events.json
  demo.json
]
files = files.map do |x|
  [x, open(File.join(__dir__, "./#{x}")).read] # rubocop:disable Security/Open (reason: inputs are safe strings)
end
files = files.to_h

def run_report(rep, name, src)
  rep.report("#{name} - simdjson") do
    Simdjson.parse(src)
  end
  rep.report("#{name} - OJ") do
    Oj.load(src)
  end
  rep.report("#{name} - standard JSON") do
    JSON.parse(src)
  end
end

Benchmark.ips do |rep|
  files.each do |name, src|
    run_report(rep, name, src)
  end
end
