module Huzzah
  module Locator
    def locator(name, &block)
      define_method(name) do |*args|
        block.call % args
      end
    end
  end
end