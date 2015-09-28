class SearchFlow < Huzzah::Flow

  def google_to_bing
    google.home.keywords.set('Hello, World!')
    google.home.search_button.click
    #Framework is faster than the browser.
    #Google doesn't finish before bing's visit method is executed
    #We should find a more elegant solution for things like this
    #sleep 2
    bing.home_page.search_box.set('Hello, World!')
    bing.home_page.search_button.click
  end

end