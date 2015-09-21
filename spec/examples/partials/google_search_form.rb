class GoogleSearchForm < Huzzah::Partial

  locator(:keywords) { text_field(name: 'q') }

end