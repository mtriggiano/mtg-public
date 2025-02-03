require 'rails_helper'

RSpec.describe "tickets/show", type: :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      title: "Title",
      body: "MyText",
      priority: 2,
      function_points: 3,
      file: "File",
      state: "State",
      state_changed_by: "",
      company: nil,
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/File/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
