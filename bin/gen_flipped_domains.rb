#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "/../lib"))
require "bit_shifter"

domain = ARGV.first
shifter = BitterDomain::BitShifter.new(domain)
shifted_domains = shifter.get_shifted_domains()

shifted_domains.each { |shift| $stdout.puts shift }
