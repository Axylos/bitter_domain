require 'whois'
require 'whois-parser'

module BitterDomain
  class DomainChecker
    attr_reader :available, :errors, :tested 
    def initialize(domains)
      @domains = domains
      @available = []
      @errors = []
      @tested = []
      @whois = Whois::Client.new
    end

    def test_domains(domains)

      domains.each do |url|
        begin
          record = whois.lookup(url)
          @tested.push(url)
          is_available = record.parser.available?
          @available.push(url) if is_available
        rescue Exception
          @errors.push(url)
        end
      end
    end
  end
end
