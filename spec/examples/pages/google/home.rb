module Google
  class Home < Huzzah::Page

    partial(:search_form, Google::SearchForm)

    locator(:search) { div(id: 'search') }

  end
end