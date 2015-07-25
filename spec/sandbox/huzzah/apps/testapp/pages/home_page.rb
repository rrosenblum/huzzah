require 'huzzah/page'

module Testapp
  class HomePage < Huzzah::Page

    partial(:header, Testapp::Header)

    let(:main_div)    { div(id: 'main') }
    let(:main_title)  { span(class: 'title').text }

  end
end