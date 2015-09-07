module Google
  class Results < Huzzah::Page

    partial :search_form, GoogleSearchForm

    locator(:results)      { div(id: 'search') }
    locator(:result_link)  { |link_text| results.link(text: link_text).when_present }

  end
end