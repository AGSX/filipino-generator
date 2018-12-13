#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'filipino_generator'

N = ARGV[0] ? ARGV[0].to_i : 1

GENERATED = Array.new(N).map do
  Person.generate
end

CAMELIZED_HASH = GENERATED.as_json.map do |p|
  p.deep_transform_keys { |key| key.to_s.camelize(:lower) }
end

puts CAMELIZED_HASH.to_json
