#!/usr/bin/env ruby

require 'thor'
require 'bitter_domain'

class CLI < Thor
  default_task :gen_shifts
  package_name "Bitter Domain"

  desc "get a list of bit flipped domains", "Generate a list of domains 1 bit away from a given domain and check availability with whois"
  method_option "retry".to_sym, aliases: ['-r'], desc: 'retry any domain that errored out; usually due to a connection reset', type: :boolean, default: false
  method_option "flips-only".to_sym, aliases: ['-s'], desc: 'limit output to just flips', type: :boolean, default: false
  method_option :url, aliases: ['-u'], desc: 'url to generate shifts for', required: true
  method_option :verbose, aliases: ['-v'], desc: 'print verbose output'
  def gen_shifts()
    host, ext = options[:url].split(".")
    shifter = BitterDomain::BitShifter.new(host)
    shifted_domains = shifter.get_shifted_domains()
      .map { |dom| "#{dom}.#{ext}" }

    if options["flips-only".to_sym]
      shifted_domains.each { |shift| $stdout.puts "#{shift}" }
    else
      checker = BitterDomain::DomainChecker.new(shifted_domains)
      checker.test_domains
      checker.retry if options[:retry]
      options[:verbose] ? checker.print_verbose : checker.print_available
    end
  end
end

CLI.start
