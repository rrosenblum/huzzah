module Wikipedia
  class ContentPage < Huzzah::Page

    locator(:first_heading)   { h1(id: 'firstHeading').when_present }
    value(:page_header)       { first_heading.text }

  end
end