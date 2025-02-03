require 'rails_helper'

RSpec.describe "tickets/index", type: :view do
  before(:each) do
    assign(:tickets, [
      Ticket.create!(
        title: "Title",
        body: "MyText",
        priority: 2,
        function_points: 3,
        file: "File",
        state: "State",
        state_changed_by: "",
        company: nil,
        user: nil
      ),
      Ticket.create!(
        title: "Title",
        body: "MyText",
        priority: 2,
        function_points: 3,
        file: "File",
        state: "State",
        state_changed_by: "",
        company: nil,
        user: nil
      )
    ])
  end

  it "renders a list of tickets" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: "File".to_s, count: 2
    assert_select "tr>td", text: "State".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
