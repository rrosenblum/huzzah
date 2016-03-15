# :nodoc:
module Huzzah
  module FlowBuilder

    private

    def generate_flow_methods!
      Huzzah::Flow.subclasses.each do |subclass|
        define_singleton_method(subclass.to_s.demodulize.underscore) do
          subclass.new(@role_data, @browser)
        end
      end
    end

  end
end
