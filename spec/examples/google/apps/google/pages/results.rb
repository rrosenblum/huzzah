module Google
  class Results < Huzzah::Page

    partial :search_form, Google::SearchForm

    locator(:results)      { div(id: 'search') }
    locator(:result_link)  { |link_text| results.link(text: link_text).when_present }

    action(:view_result)   { |link_text| result_link(link_text).click }
    value(:search_terms)   { search_form.keywords.value }

  end
end