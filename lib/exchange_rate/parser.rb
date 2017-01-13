require 'ox'

module Parser
  class Parser::Plain
    def initialize(xml_string)
      @xml = xml_string
    end

    def parse
      Ox.parse(@xml)
    end
  end
end
