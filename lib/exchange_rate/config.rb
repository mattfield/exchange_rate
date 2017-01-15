require 'yaml'

module Config
  class << self
    # Opens the configuration file and returns the value of a entry
    # at `name`
    #
    # @param name [Symbol] The name of the YAML entry to be fetched
    # @return [Any] The value of entry requested, or nil if
    #   the configuration file does not exist
    def config_file(name)
      path = Pathname.new('config/exchange_rate.yml')
      contents = File.read(path)
      hash = YAML.load(contents)
      hash[name]
    rescue Errno::ENOENT
      nil
    end

    # Delegates the lookup of a YAML entry
    #
    # @param name [Symbol] The name of the YAML entry to be fetched
    # @return [Any] The value of entry requested
    def load(name)
      config_file "#{name}"
    end

    # Initialises a config hash and creates (and memoizes) the value
    # of the requested entry
    #
    # @param name [String] The value to be looked up
    def [](name)
      @config ||= {}
      @config[name.to_sym] ||= load(name)
    end

    # Returns a string representation of the config hash
    #
    # @return [String] Config hash as a string
    def inspect
      @config.inspect
    end
  end
end
