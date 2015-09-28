module Huzzah
  module FlowBuilder

    private

    def generate_flow_methods!
      Huzzah::Flow.subclasses.each do |flow|
        define_singleton_method(flow.to_s.demodulize.underscore) { flow.new(self) }
      end
    end

  end
end