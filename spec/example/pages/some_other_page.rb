module SomeOtherSite
  class SomeOtherPage < Huzzah::Page

    locator(:some_element) { "Hi! from from #{self}" }

  end
end