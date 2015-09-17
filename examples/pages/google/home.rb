module Google
  class Home < Huzzah::Page

    include_partial GoogleSearchForm

    locator(:search)     { search_form.keywords }

  end
end