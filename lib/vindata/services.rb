module VinData
  module Services
    extend self

    # Supported service list
    def service_list
      [
        :edmunds,
        :nada,
        :nada_restful
      ]
    end

    def get(name)
      @services = {} unless defined?(@services)
      @services[name] = spawn(name) unless @services.include?(name)
      @services[name]
    end

    def configuration
      VinData.config
    end

    private # -----------------------------------------------------------------

    ##
    # Spawn a Lookup of the given name.
    #
    def spawn(name)
      if service_list.include?(name)
        VinData::Services.const_get(classify_name(name)).new
      else
        valids = service_list.map(&:inspect).join(", ")
        raise ConfigurationError, "Please specify a valid service for VinData " +
          "(#{name.inspect} is not one of: #{valids})."
      end
    end

    ##
    # Convert an "underscore" version of a name into a "class" version.
    #
    def classify_name(filename)
      filename.to_s.split("_").map{ |i| i[0...1].upcase + i[1..-1] }.join
    end
  end
end

VinData::Services.service_list.each do |name|
  require "vindata/services/#{name}"
end
