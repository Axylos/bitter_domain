#!/usr/bin/env ruby

require 'thor'
require 'bitter_domain'

class CLI < Thor
  default_task :gen_shifts
  package_name "Bitter Domain"

  desc "do a thing", "more stuff"
  method_option "flips-only".to_sym, alias: '-s', desc: 'limit output to just flips', type: :boolean, default: false
  def gen_shifts(domain)
    host, ext = domain.split(".")
    shifter = BitterDomain::BitShifter.new(host)
    shifted_domains = shifter.get_shifted_domains()
      .map { |dom| "#{dom}.#{ext}" }

    if options["flips-only".to_sym]
      shifted_domains.each { |shift| $stdout.puts "#{shift}" }
    else
      p 'whoopsie'
    end
  end
end

CLI.start
