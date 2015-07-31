module Huzzah
  class Site

    attr_accessor :name, :url, :data

    def initialize(name, data, environment)
      @name = name
      @data = OpenStruct.new YAML.load_file(data)[environment]
      @url = @data.url
    end

    def method_missing(method_name, *args, &block)
      if @data.respond_to? method_name
        @data.send method_name
      else
        fail Huzzah::NoMethodError,
             "Method '#{method_name}' undefined for #{name} site."
      end
    end

  end
end
