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
      self.shifted_domains.each { |shift| $stdout.puts "#{shift}" }
    end

    def domain=(domain)
      self.domain = parse_domain(domain)
      gen_shifts
    end

    def check_domains(attempt_retry=false)
      self.checker = BitterDomain::DomainChecker.new(@shifted_domains)
      self.checker.test_domains
      
      self.checker.retry if attempt_retry

      self.checker.available
    end

    def get_available
      self.checker.available
    end

    def get_errors
      self.checker.errors
    end

    def get_tested
      self.checker.tested
    end

    def retry
      self.checker.retry
    end

    def print_verbose
      self.checker.print_verbose
    end

    def print_available
      puts "Here are the available shifted domains"
      self.checker.print_available
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
