class EntityBankPresenter < BasePresenter
	presents :bank
	delegate :id, to: :bank
	delegate :name, to: :bank
	delegate :branch_office, to: :bank
	delegate :cuit, to: :bank
	delegate :denomination, to: :bank

	def action_links
	    content_tag :div do
	      	concat(link_to_edit [:edit, bank], {id: "edit_bank", data:{target: "#edit_bank_modal", toggle: "modal", form: true}})
	      	concat(link_to_destroy bank)
	    end
	end
end