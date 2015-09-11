module SomeSite
  class SomePage < Huzzah::Page
    include_partial SomePartial

    locator(:some_element) { "Hi! from from #{self}" }

  end
end