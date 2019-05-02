module Google
  class SearchForm < Huzzah::Page

    locator(:keywords) { text_field(name: 'q') }
    locator(:search_button) { input(aria_label: 'Google Search') }
    locator(:search_results) { ol(id: 'rso') }

  end
end
