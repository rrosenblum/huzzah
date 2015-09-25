module Huzzah
  class Flow

    def initialize(role)
      @role = role
    end

    def method_missing(method_name, *args, &block)
      return @role.send(method_name, *args) if @role.respond_to?(method_name, false)
      super
    end

    def respond_to?(method_name, include_private = false)
      @role.respond_to?(method_name, include_private) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      @role.respond_to?(method_name, include_private) || super
    end

  end
end