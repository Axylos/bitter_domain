# frozen_string_literal: true

require 'uri/http'
require 'public_suffix'

module BitterDomain
  class DomainMapper
    attr_reader :shifted_domains
    attr_reader :domain

    def initialize(domain)
      @domain = parse_domain(domain)
      @checker = nil
      @shifted_domains = []
    end

    def gen_shifts
      host = @domain.sld
      shifter = BitterDomain::BitShifter.new(host)
      self.checker = nil
      @shifted_domains = shifter.get_shifted_domains
                                .map { |dom| "#{dom}.#{@domain.tld}" }
    end

    def print_shifts
      shifted_domains.each { |shift| $stdout.puts shift.to_s }
    end

    def domain=(domain)
      self.domain = parse_domain(domain)
      gen_shifts
    end

    def check_domains(attempt_retry = false)
      self.checker = BitterDomain::DomainChecker.new(@shifted_domains)
      checker.test_domains

      checker.retry if attempt_retry

      checker.available
    end

    def get_available
      checker.available
    end

    def get_errors
      checker.errors
    end

    def get_tested
      checker.tested
    end

    def retry
      checker.retry
    end

    def print_verbose
      checker.print_verbose
    end

    def print_available
      puts 'Here are the available shifted domains'
      checker.print_available
    end

    def query_shifts
      gen_shifts
      check_domains

      get_available
    end

    protected

    attr_accessor :checker
    def parse_domain(url)
      uri = URI.parse(url)
      uri = URI.parse("http://#{url}") if uri.scheme.nil?
      host = uri.host.downcase

      PublicSuffix.parse(host)
    end
  end
end
