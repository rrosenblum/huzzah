module TestSite
  class Home < Huzzah::Page

    let(:full_name)      { text_field(id: 'full_name') }
    let(:set_full_name)  { |name| full_name.when_present.set name }
    let(:launch_popup)   { link(text: 'Launch Popup').when_present.click }
    let(:role_list)      { select_list(id: 'role') }

  end
end