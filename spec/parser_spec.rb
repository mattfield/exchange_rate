require "exchange_rate/parser"

describe Parser::Plain do
  before(:all) do
    @xml = File.open(Config[:feed_path]) { |f| f.read }
    @parser = Parser::Plain.new @xml
  end

  it "should not accept a File type as an argument" do
    expect {
      Parser::Plain.new(File.open Config[:feed_path]).parse
    }.to raise_error TypeError
  end

  it "should accept a String as an argument" do
    expect {
      Parser::Plain.new(File.open(Config[:feed_path]).read).parse
    }.to_not raise_error
  end

  context "Parser::Plain#parse" do
    it "should return a Ox Document" do
      expect(@parser.parse).to be_a Ox::Document
    end
  end
end
