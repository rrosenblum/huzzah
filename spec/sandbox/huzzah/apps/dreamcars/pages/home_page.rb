require 'huzzah/page'

module Dreamcars
  class HomePage < Huzzah::Page

    partial(:header, Dreamcars::Header)

    let(:location_label)     { p(text: 'Contact Us') }
    let(:select_location)    { |location| select_list(id: 'location').when_present.select location }
    let(:set_pick_up_date)   { |date| text_field(id: 'pick_up_date').set date }
    let(:set_drop_off_date)  { |date| text_field(id: 'drop_off_date').set date }
    let(:search)             { button(value: 'Check Availability').when_present.click }

    def availability_search(location, pick_up_date, drop_off_date)
      select_location location
      set_pick_up_date pick_up_date
      set_drop_off_date drop_off_date
      search
    end

  end
end