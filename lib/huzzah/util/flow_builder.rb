# :nodoc:
module Huzzah
  module FlowBuilder

    private

    def generate_flow_methods!
      Huzzah::Flow.subclasses.each do |subclass|
        flow_name = subclass.to_s.demodulize.underscore
        define_singleton_method(flow_name) do
          flow = subclass.new
          flow.role_data = @role_data
          flow.browser = @browser
          flow
        end
      end
    end

  end
end
