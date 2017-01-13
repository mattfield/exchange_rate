require 'rexml/document'
require 'exchange_rate/parser'

class Feed
  include Enumerable

  def initialize(file_path=nil)
    @file_path = file_path ||= ENV["XML_FEED_PATH"]
    @raw = read_file(file_path)
    parse
  end

  attr_reader :raw
  attr_accessor :file_path

  def read_file(file_path)
    File.open(file_path) { |f| f.read }
  end

  def parse
    @parsed = Parser::Plain.new(@raw).parse
  end
end

class ECBFeed < Feed
  def each
    @parsed.locate("gesmes:Envelope/Cube/*/").each { |day|
      date = Date.parse(day.time)
      day.nodes().each { |date_node|
        yield(
          date: date,
          iso: date_node.currency,
          rate: Float(date_node.rate)
        )
      }
    }
  end
end
