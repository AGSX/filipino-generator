#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'filipino_generator'

N = ARGV[0] ? ARGV[0].to_i : 3

GENERATED = N.times.map do
  Person.generate
end

puts GENERATED.to_json
