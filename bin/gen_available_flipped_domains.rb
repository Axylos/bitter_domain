#!/usr/bin/env ruby

require 'whois'
require 'whois-parser'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "/../lib"))
require "bit_shifter"

whois = Whois::Client.new

original_url = ARGV.first
domain, extension = original_url.split("\.")

shifter = BitterDomain::BitShifter.new(domain)
shifted_domains = shifter.get_shifted_domains()

tested = []
available = []
errors = []
shifted_domains.each do |name|
  begin
    url = "#{name}.#{extension}"
    record = whois.lookup(url)
    tested.push(url)
    is_available = record.parser.available?
    available.push(url) if is_available
  rescue Exception
    errors.push(url)
  end
end

def printer(vals)
  vals.each { |val| $stdout.puts val }
end

$stdout.puts "Here are the available domains:"
printer(available)

puts "\n"
puts "\n"

$stdout.puts "Here are the tested domains"
printer(tested)

puts "\n"
puts "\n"

$stdout.puts "Here are the errors"
printer(errors)
