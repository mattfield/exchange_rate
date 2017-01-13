require 'rexml/document'
require 'exchange_rate/parser'

class Feed
  include Enumerable

  def initialize(file_path=nil)
    @file_path = file_path ||= ENV["XML_FEED_PATH"]
    @raw = read_file(file_path)
    parse
  end

  # @return [String] A string representation of read XML
  attr_reader :raw

  # Opens a file at `file_path` and reads
  #
  # @param file_path [String] Path to XML on disk
  # @return [String] String of XML file contents
  def read_file(file_path)
    File.open(file_path) { |f| f.read }
  end

  # Parses raw XML using whatever Parser is provided
  #
  # @return [Ox::Document] An Ox-parsed XML document
  def parse
    @parsed = Parser::Plain.new(@raw).parse
  end
end

class ECBFeed < Feed
  # Enumerator for ECB feed data
  #
  # @return [Enumerator<Hash>] Returns an Enumerator that itself
  #   return a Hash of rate information
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
