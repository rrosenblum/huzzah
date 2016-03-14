class AnotherFlow < Huzzah::Flow

  def bing_to_google
    bing.home_page.search_box.set('Hello, World!')
    bing.home_page.search_button.click
    google.visit
    google.home.keywords.set('Hello, World!')
    google.home.search_button.click
  end

end