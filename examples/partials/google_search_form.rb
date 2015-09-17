class GoogleSearchForm < Huzzah::Partial

  locator(:keywords) { text_field(name: 'q').when_present }

end