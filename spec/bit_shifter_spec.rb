require_relative 'spec_helper'
require './lib/bitter_domain/bit_shifter'

RSpec.describe BitterDomain::BitShifter do
  let(:old_domain) { "tumblr" }
  subject { BitterDomain::BitShifter.new(old_domain) }
  it 'should exist' do
    expect(subject).not_to be_nil
  end

  describe "#get_shifted_domains" do
    let(:domains) { subject.get_shifted_domains }

    it 'should return an array' do
      expect(domains).to be_a(Array)
    end

    it 'should reject invalid domains' do
      expect(domains).not_to include("|umblr")
    end

    it 'should only have values one letter off from original' do
      has_only_flips = domains.all? do |domain|
        diffs = 0
        chars = domain.split("")
        old_chars = old_domain.split("")
        chars.each.with_index do |char, idx|
          diffs += 1 if char != old_chars[idx]
        end

        diffs == 1
      end
      expect(has_only_flips).to be(true) 
    end

    it 'should correctly shift fbcdn' do
      dom = BitterDomain::BitShifter.new('fbcdn')
      shifts = dom.get_shifted_domains
      expect(shifts).to include("gbcdn")
    end

    context '#gen_shifts' do
      before { allow(subject).to receive(:gen_shifts) { [3] } }
      it 'should call gen_shifts with a shift of "t"' do
        expect(subject).to receive(:gen_shifts)
        subject.get_shifted_domains
      end
    end

    it 'should not be empty' do
      expect(domains).not_to be_empty
    end
  end

  describe "#gen_shifts" do
    let (:shifts) { subject.gen_shifts(97) }

    it 'should return an array' do
      expect(shifts).to be_a(Array)
    end

    it 'should contain a bit down shift' do
      expect(shifts.first).to eq(96)
    end

    it 'should contain a bit up shift' do
      expect(shifts).to include(99)
    end
  end

  describe '#valid_domain?' do
    it 'can validate a domain with only chars' do
      expect(subject.valid_domain?('tumblr')).to be true
    end

    it 'rejects a domain that starts with a hyphen' do
      expect(subject.valid_domain?('-umblr')).to be false
    end

    it 'rejects a domain that ends with a hyphen' do
      expect(subject.valid_domain?('tumbl-')).to be false
    end

    it 'rejects a domain with an ampersand' do
      expect(subject.valid_domain?('tum&br')).to be false
    end
  end
end
