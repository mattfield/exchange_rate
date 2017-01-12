require 'rexml/document'

class Feed
  include Enumerable

  def initialize file_path
    @file_path = file_path
    @raw = read_file(file_path)
    parse
  end

  attr_reader :file_path, :raw

  def read_file(file_path)
    File.open(file_path) { |f| f.read }
  end

  def parse
    @parsed = REXML::Document.new @raw
  end
end

class ECBFeed < Feed
  def parse
    super
  end

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
