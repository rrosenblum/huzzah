require 'huzzah/page'

module Testapp
  class Header < Huzzah::Page

    let(:partial_foo)      { div(id: 'main') }

  end
end