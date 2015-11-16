module Huzzah
  module PartialBuilder

    private

    ##
    # Defines a method with the given name that returns an instance of
    # a partial page class.
    #
    #    include_partial(Partial::Class)
    #    Include_partial(Google::Header)
    #
    def include_partial(partial_class)
      define_method(partial_class.to_s.demodulize.underscore.to_sym) do |&block|
        partial = partial_class.new
        partial.role_data = @role_data
        partial.browser = @browser
        partial.instance_eval(&block) if block
        partial
      end
    end

  end
end