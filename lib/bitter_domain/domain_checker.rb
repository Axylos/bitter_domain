# frozen_string_literal: true

require 'whois'
require 'whois-parser'
require 'colorize'

module BitterDomain
  class DomainChecker
    attr_reader :available, :errors, :tested
    def initialize(domains)
      @domains = domains
      @available = []
      @errors = []
      @tested = []
      @whois = Whois::Client.new
      @error_msgs = []
    end

    def print_verbose
      puts "\n\nHere are all the tested domains\n".blue
      @tested.each { |domain| puts domain }

      if @errors.any?
        puts "\n\nHere are all of the domains that errored out\n".red
        @errors.each { |domain| puts domain }
      end

      if @error_msgs.any?
        puts "\n\nHere are the error messages\n".red
        @error_msgs.each { |msg| puts msg }
      end

      rejected = @tested - @available
      if rejected.any?
        puts "\n\nHere are the rejected domains".yellow
        rejected.each { |dom| puts dom }
      end

      puts "\n\nHere are the available domains\n".green
      print_available
    end

    def print_available
      @available.each { |domain| puts domain }
      puts 'No available domains' if @available.empty?
    end

    def test_domains
      query_domains(@domains)
    end

    def retry
      copies = @errors.dup
      @errors = []
      query_domains(copies)
    end

    private

    def query_domains(domains)
      domains.each do |url|
        begin
          record = @whois.lookup(url)
          @tested.push(url)
          is_available = record.parser.available?
          @available.push(url) if is_available
        rescue Exception => e
          @error_msgs.push(e)
          @errors.push(url)
        end
      end
    end
  end
end
