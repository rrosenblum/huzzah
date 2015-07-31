module TestSite
  class Home < Huzzah::Page

    locator(:full_name)      { text_field(id: 'full_name') }
    locator(:launch_popup)   { link(text: 'Launch Popup').when_present }
    locator(:role_list)      { select_list(id: 'role') }

  end
end