require 'exchange_rate/feed'

describe Feed do
  before(:all) do
    @feed = Feed.new
  end

  it "should return raw XML" do
    expect(@feed.raw).to be_a String
  end
end

describe ECBFeed do
  before(:all) do
    @feed = ECBFeed.new
  end

  it "should be a subclass of Feed" do
    expect(@feed).to be_a Feed
  end

  context "ECBFeed#each" do
    it "should yield an Array of rate hashes" do
      expect(@feed.each { |x| x }).to be_a Array
    end
  end
end
