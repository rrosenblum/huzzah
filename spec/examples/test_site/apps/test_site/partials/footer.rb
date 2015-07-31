module TestSite
  class Footer < Huzzah::Page

    locator(:footer_div) { div(id: 'footer').when_present }
    locator(:copyright)  { footer_div.span(id: 'copyright') }

  end
end