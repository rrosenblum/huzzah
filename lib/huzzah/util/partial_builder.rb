module Huzzah
  module PartialBuilder

    private

    ##
    # Defines a method with the given name that returns an instance of
    # a partial page class.
    #
    #    partial(:partial_name, Partial::Class)
    #    partial(:header, Google::Header)
    #
    def partial(method_name, partial_class)
      define_method(method_name.to_s) do |&block|
        partial = partial_class.new
        partial.role_data = @role_data
        partial.browser = @browser
        partial.instance_eval(&block) if block
        partial
      end
    end

  end
end