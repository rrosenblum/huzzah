module Watir
  class Select

    def selected_option
      selected_options.first.text
    end

    def available_options
      options.map(&:text)
    end

  end
end
