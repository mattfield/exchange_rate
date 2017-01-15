require "exchange_rate/config"

describe Config do
  context "Config#[]" do
    it "should pull in the value of a YAML key by name" do
      expect(Config[:feed_path]).to eq "spec/fixtures/example.xml"
    end
  end

  context "Config#inspect" do
    it "should allow inspection of the current config hash" do
      expect(Config.inspect).to eq("{:feed_path=>\"spec/fixtures/example.xml\"}")
    end
  end
end
