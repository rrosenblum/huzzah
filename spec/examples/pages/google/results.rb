module Google
  class Results < Huzzah::Page

    include_partial(Google::SearchForm)

    locator(:results) { div(id: 'search') }
    locator(:result_link) { |link_text| results.link(text: link_text) }
    locator(:bing_link) { link(text: 'Bing') }

  end
end
