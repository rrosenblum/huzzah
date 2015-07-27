module TestSite
  class Footer < Huzzah::Page

    let(:footer_div) { div(id: 'footer').when_present }
    let(:copyright)  { footer_div.span(id: 'copyright').text }

  end
end