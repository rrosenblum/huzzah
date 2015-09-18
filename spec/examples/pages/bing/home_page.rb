module Bing
  class HomePage < Huzzah::Page

    locator(:search_box)  { text_field(id: 'sb_form_q') }

  end
end