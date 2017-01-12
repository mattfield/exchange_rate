require "spec_helper"

describe ExchangeRate do
  it "has a version number" do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  describe "ExchangeRate#at" do
    before(:all) do
      ENV["XML_FEED_PATH"] = "spec/fixtures/example.xml"
    end

    it "should fetch an exchange rate" do
      expect(ExchangeRate.at("2017-01-10", 'USD', 'GBP')).to eq 0.82275
    end

    it "should accept either a Date or String" do
      expect(ExchangeRate.at(Date.new(2017,01,10), 'USD', 'GBP')).to eq 0.82275
      expect(ExchangeRate.at("2017-01-10", 'USD', 'GBP')).to eq 0.82275
    end
  end
end
