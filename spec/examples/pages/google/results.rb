module Google
  class Results < Huzzah::Page

    partial(:search_form, Google::SearchForm)

    locator(:results) { div(id: 'search') }
    locator(:result_link) { |link_text| results.link(text: link_text).when_present }
    locator(:bing_link) { link(text: 'Bing') }

  end
end