module Huzzah
  class Flow

    def initialize(role)
      @role = role
    end

    def method_missing(method_name, *args, &block)
      if @role.respond_to?(method_name, false)
        define_singleton_method(method_name) do |*args|
          @role.send(method_name, *args, &block)
        end
        @role.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      @role.respond_to?(method_name, include_private) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      @role.respond_to?(method_name, include_private) || super
    end

  end
end