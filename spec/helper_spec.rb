require 'exchange_rate/helper'

describe Helper do
  describe "Helper::is_weekday?" do
    it "should return true when a provided date is a weekday" do
      expect(Helper::is_weekday? Date.new(2017,01,9)).to eq true
      expect(Helper::is_weekday? Date.new(2017,01,10)).to eq true
      expect(Helper::is_weekday? Date.new(2017,01,11)).to eq true
      expect(Helper::is_weekday? Date.new(2017,01,12)).to eq true
      expect(Helper::is_weekday? Date.new(2017,01,13)).to eq true
    end

    it "should return false when a provided date is at the weekend" do
      expect(Helper::is_weekday? Date.new(2017,01,7)).to eq false
      expect(Helper::is_weekday? Date.new(2017,01,8)).to eq false
    end
  end

  describe "Helper::ensure_weekday" do
    it "should return the provided date when it is a weekday" do
      expect(Helper::ensure_weekday Date.new(2017,01,9)).to eq Date.new(2017,01,9)
      expect(Helper::ensure_weekday Date.new(2017,01,10)).to eq Date.new(2017,01,10)
      expect(Helper::ensure_weekday Date.new(2017,01,11)).to eq Date.new(2017,01,11)
      expect(Helper::ensure_weekday Date.new(2017,01,12)).to eq Date.new(2017,01,12)
      expect(Helper::ensure_weekday Date.new(2017,01,13)).to eq Date.new(2017,01,13)
    end

    it "should return the nearest previous weekday when provided with a date that is at a weekend" do
      expect(Helper::ensure_weekday Date.new(2017,01,7)).to eq Date.new(2017,01,6)
      expect(Helper::ensure_weekday Date.new(2017,01,8)).to eq Date.new(2017,01,6)
    end
  end
end
