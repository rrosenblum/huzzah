class SearchFlow < Huzzah::Flow

  def google_to_bing
    google.home.keywords.set('Hello, World!')
    google.home.search_button.click
    sleep 1 #for some reason this is necessaryclear

    bing.home_page.search_box.set('Hello, World!')
    bing.home_page.search_button.click
  end

end