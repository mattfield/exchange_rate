require 'rexml/document'

class Feed
  include Enumerable

  def initialize(file_path="spec/fixtures/example.xml")
    @file_path = file_path
    @raw = read_file(file_path)
    parse
  end

  attr_reader :raw
  attr_accessor :file_path

  def read_file(file_path)
    File.open(file_path) { |f| f.read }
  end

  def parse
    @parsed = REXML::Document.new @raw
  end
end

class ECBFeed < Feed
  def each
    REXML::XPath.each(@parsed, '/gesmes:Envelope/Cube/Cube[@time]') do |day|
      date = Date.parse(day.attribute('time').value)
      REXML::XPath.each(day, './Cube') do |currency|
        yield(
          date: date,
          iso: currency.attribute('currency').value,
          rate: Float(currency.attribute('rate').value)
        )
      end
    end
  end
end
