module BitterDomain
  class BitShifter
    # accept alphanumeric chars and hyphens
    # but no hyphens at the beginning or end of the domain
    PATTERN = /^[A-Za-z0-9]-?[A-Za-z0-9-]+[A-Za-z0-9]$/

    def initialize(domain)
      @domain = domain
    end

    def valid_domain?(domain)
      domain.match? PATTERN
    end

    def gen_shifts(byte)
      # left-shift 1 through each bit of the byte
      # and XOR to flip a single one at each position
      shifts = []
      8.times do |i|
        shifted = byte ^ (1 << i)
        shifts.push(shifted)
      end

      shifts
    end

    def get_shifted_domains
      bytes = @domain.bytes
      domains = []

      # iterate over a byte array for the original domain
      # get a set of flips for each byte, swap each new byte
      # and then stringify
      bytes.each.with_index do |byte, idx|
        shifts = gen_shifts(byte)
        swapped_domains = shifts.map do |byte| 
          copied_bytes = bytes.dup
          copied_bytes[idx] = byte
          copied_bytes
            .map(&:chr)
            .join("")
        end
        domains.concat(swapped_domains)
      end

      # kick out anything that doesn't match the pattern above
      domains.keep_if { |domain| valid_domain?(domain) }
    end
  end
end
