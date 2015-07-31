module Huzzah
  class Role

    attr_accessor :name, :data, :session

    def initialize(role_name, role_data, environment)
      @name = role_name
      unless role_data.nil?
        @data = OpenStruct.new YAML.load_file(role_data)[environment]
      end
      @session = Huzzah::Session.new user_type
    end

    def user_type
      if @data.respond_to? :user_type
        @data.user_type.to_sym
      else
        :web
      end
    end

    def method_missing(method_name, *args, &block)
      if @data.respond_to? method_name
        @data.send method_name, *args, &block
      else
        fail Huzzah::NoMethodError,
             "Method '#{method_name}' undefined for #{self.class}"
      end
    end

  end
end
