module Google
  class Home < Huzzah::Page
    include_partial GoogleSearchForm

    locator(:search) { div(id: 'search') }

  end
end