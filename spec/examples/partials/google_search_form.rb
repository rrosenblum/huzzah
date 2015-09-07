class GoogleSearchForm < Huzzah::Page

  locator(:keywords)     { text_field(name: 'q').when_present }

end