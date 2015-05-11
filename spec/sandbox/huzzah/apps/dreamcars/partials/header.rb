require 'huzzah/page'

module Dreamcars
  class Header < Huzzah::Page

    let(:contact_us)      { div(id: 'top').link(text: 'Contact Us').when_present.click }
    let(:nav_links)       { div(id: 'nav_links') }
    let(:view_home)       { nav_links.link(text: 'Home').when_present.click }
    let(:view_locations)  { nav_links.link(text: 'Locations').when_present.click }
    let(:view_our_cars)   { nav_links.link(text: 'Home').when_present.click }

  end
end