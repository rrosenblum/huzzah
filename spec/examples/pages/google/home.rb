module Google
  class Home < Huzzah::Page

    include_partial(Google::SearchForm)

    locator(:search) { div(id: 'search') }

  end
end