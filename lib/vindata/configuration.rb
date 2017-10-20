require 'singleton'

module VinData
  def self.configure(options = nil, &block)
    if !options.nil?
      Configuration.instance.configure(options)
    end
  end

  def self.config
    Configuration.instance.data
  end

  class Configuration
    include Singleton

    OPTIONS = [
      :service,
      :api_key
    ]

    attr_accessor :data

    def self.set_defaults
      instance.set_defaults
    end

    OPTIONS.each do |o|
      define_method o do
        @data[o]
      end
      define_method "#{o}=" do |value|
        @data[o] = value
      end
    end

    def configure(options)
      @data.merge!(options)
    end

    def initialize # :nodoc
      # @data = VinData::ConfigurationHash.new
      @data = {}
      set_defaults
    end

    def set_defaults

      # geocoding options
      @data[:service]      = :edmunds    # Default service to look up vins with
      @data[:api_key]      = nil         # API key for geocoding service

    end

    instance_eval(OPTIONS.map do |option|
      o = option.to_s
      <<-EOS
      def #{o}
        instance.data[:#{o}]
      end

      def #{o}=(value)
        instance.data[:#{o}] = value
      end
      EOS
    end.join("\n\n"))

  end

  # class ConfigurationHash < Hash
  #   include HashRecursiveMerge
  #
  #   def method_missing(meth, *args, &block)
  #     has_key?(meth) ? self[meth] : super
  #   end
  # end
end
