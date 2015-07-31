module Google
  class Home < Huzzah::Page

    partial :search_form, Google::SearchForm

    locator(:search)     { search_form.keywords }

  end
end