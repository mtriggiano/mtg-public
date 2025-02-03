require 'rails_helper'

RSpec.describe "tickets/new", type: :view do
  before(:each) do
    assign(:ticket, Ticket.new(
      title: "MyString",
      body: "MyText",
      priority: 1,
      function_points: 1,
      file: "MyString",
      state: "MyString",
      state_changed_by: "",
      company: nil,
      user: nil
    ))
  end

  it "renders new ticket form" do
    render

    assert_select "form[action=?][method=?]", tickets_path, "post" do

      assert_select "input[name=?]", "ticket[title]"

      assert_select "textarea[name=?]", "ticket[body]"

      assert_select "input[name=?]", "ticket[priority]"

      assert_select "input[name=?]", "ticket[function_points]"

      assert_select "input[name=?]", "ticket[file]"

      assert_select "input[name=?]", "ticket[state]"

      assert_select "input[name=?]", "ticket[state_changed_by]"

      assert_select "input[name=?]", "ticket[company_id]"

      assert_select "input[name=?]", "ticket[user_id]"
    end
  end
end
