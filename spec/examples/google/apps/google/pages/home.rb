module Google
  class Home < Huzzah::Page

    partial :search_form, Google::SearchForm

    action(:search_for)     { |text| search_form.keywords.set text }

  end
end