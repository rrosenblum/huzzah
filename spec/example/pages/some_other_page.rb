module SomeOtherSite
  class SomeOtherPage < Huzzah::Page

    locator(:blah) { "Hi! from from #{self}" }

  end
end