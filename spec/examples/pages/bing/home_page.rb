module Bing
  class HomePage < Huzzah::Page
    locator(:search_box)     { text_field(id: 'sb_form_q') }
    locator(:search_button)  { label(class: 'search icon tooltip') }
  end
end
