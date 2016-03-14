class SearchFlow < Huzzah::Flow

  def google_to_bing
    google.visit
    google.home.search_form.keywords.when_present.set('Hello, World!')
    google.home.search_form.search_button.click
    sleep 2
    bing.visit
    bing.home_page.search_box.when_present.set('Hello, World!')
    bing.home_page.search_button.click
  end

  def bing_result
    google.visit
    google.home.search_form.keywords.set('Bing')
    google.home.search_form.search_button.click
    sleep 2
    google.results.bing_link.click
    bing.home_page.search_box.set('Hello, World!')
    bing.home_page.search_button.click
  end

end