class CheckbookPresenter < BasePresenter
  presents :checkbook
  delegate :number, to: :checkbook
  delegate :init_number, to: :checkbook
  delegate :final_number, to: :checkbook
  def id
    link_to "#{checkbook.id}", checkbook
  end

  def bank
    checkbook.bank.name
  end

  def action_links
    content_tag :div do
      concat(link_to_edit edit_checkbook_path(checkbook.id), {id: "edit_checkbook", data:{target: "#edit_checkbook_modal", toggle: "modal", form: true}})
      concat(link_to_destroy checkbook)
    end
  end
end
