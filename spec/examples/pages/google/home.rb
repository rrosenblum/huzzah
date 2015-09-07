module Google
  class Home < Huzzah::Page

    partial :search_form, GoogleSearchForm

    locator(:search)     { search_form.keywords }

  end
end