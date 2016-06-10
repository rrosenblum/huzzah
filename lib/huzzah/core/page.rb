require 'forwardable'

module Huzzah
  class Page < Huzzah::Base
    extend Locator
    extend Forwardable

    class << self
      private

      ##
      # Defines a method that returns an instance of a partial page class. The
      # class name is used to generate the name of the method. The module
      # namespace is ignored.
      #
      #    include_partial(Google::Header)
      #
      def include_partial(partial_class)
        class_name = partial_class.to_s.demodulize.underscore.to_sym
        define_method(class_name) do |&block|
          partial = partial_class.new
          partial.role_data = @role_data
          partial.browser = @browser
          partial.instance_eval(&block) if block
          partial
        end
      end
    end

    def_delegator :browser, :p
    def_delegator :browser, :select
  end
end
