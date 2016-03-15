module Huzzah
  module PartialBuilder

    private

    ##
    # Defines a method that returns an instance of a partial page class. The
    # class name is used to generate the name of the method. The module
    # namespace is ignored.
    #
    #    include_partial(Google::Header)
    #
    def include_partial(partial_class)
      define_method(partial_class.to_s.demodulize.underscore.to_sym) do |&block|
        partial = partial_class.new(@role_data, @browser)
        partial.instance_eval(&block) if block
        partial
      end
    end

  end
end
