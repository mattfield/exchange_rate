require 'ox'

module Parser
  class Parser::Plain
    def initialize(xml_string)
      @xml = xml_string
    end

    # Parses and returns an Ox-formatted
    # XML document
    #
    # @return [Ox::Document] Parsed XML document
    def parse
      Ox.parse(@xml)
    end
  end
end
