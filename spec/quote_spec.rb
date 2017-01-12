require 'exchange_rate/quote'

describe Quote do
  before(:all) do
    @quote = ECBQuote.new({
      'date' => Date.new(2017,01,10),
      'from' => 'EUR',
      'to'   => 'EUR'
    })
  end

  it "should allow the date to be accessed" do
    expect(@quote.date).to_not be nil
  end

  it "should ensure the date stays as a Date object" do
    expect(@quote.date).to be_a Date
  end

  context "Quote#rates" do
    it "should return a Hash of { currency => rate }" do
      expect(@quote.rates).to be_a Hash
      expect(@quote.rates).to include("AUD" => "1.44")
    end
  end

  context "Quote#get_conversion_rate" do
    it "should return a Float" do
      expect(@quote.get_conversion_rate).to be_a Float
    end

    it "should return 1 if EUR is the base currency" do
      expect(@quote.get_conversion_rate).to eq 1
    end

    it "should return the inverse if EUR is the target currency" do
      @quote.from = 'USD'
      expect(@quote.get_conversion_rate).to eq @quote.round(1 / 1.0567)
    end

    it "should return the expected conversation rate for the date given" do
      @quote.from = 'USD'
      @quote.to = 'GBP'
      expect(@quote.get_conversion_rate).to eq 0.82275
    end
  end

  context "Quote#date_in_range?" do
    it "should raise an exception if no information exists for the provided date" do
      expect { @quote.date_in_range?(Date.new(2011,1,1)) }.to raise_error Exception
    end

    it "should return the date if in the last 3 months" do
      expect(@quote.date_in_range?).to be_a Date
      expect(@quote.date_in_range?).to eq Date.new(2017,01,10)
    end
  end
end
