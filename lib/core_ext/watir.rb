module Watir

  class Element

    def onclick
      self.attribute_value("onclick")
    end

  end

  class Select

    def selected_option
      self.selected_options.first.text
    end

    def available_options
      self.options.map(&:text)
    end

  end

end