module Huzzah
  module FlowBuilder

    private

    def generate_flow_methods!
      Huzzah::Flow.subclasses.each do |flow|
        flow_instance = flow.new(self)
        flow.instance_methods(false).each do |method|
          define_singleton_method(method) do |*args|
            flow_instance.send(method, *args)
          end
        end
      end
    end

  end
end