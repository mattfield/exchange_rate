require 'yaml'

module Config
  class << self
    def config_file(name)
      path = Pathname.new('config/exchange_rate.yml')
      contents = File.read(path)
      hash = YAML.load(contents)
      hash[name]
    rescue Errno::ENOENT
      nil
    end

    def load(name)
      config_file "#{name}"
    end

    def [](name)
      @config ||= {}
      @config[name.to_sym] ||= load(name)
    end
  end
end
