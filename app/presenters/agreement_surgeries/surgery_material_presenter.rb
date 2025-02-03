class AgreementSurgeries::SurgeryMaterialPresenter < BasePresenter
  presents :surgery_material

  def id
	  surgery_material.id
  end

  def code
    surgery_material.code
  end

  def description
    surgery_material.description
  end

  def category
	surgery_material.category
  end

  def origin
	surgery_material.origin
  end

  def price
    surgery_material.price
  end

  def user
	link_to surgery_material.user.email, surgery_material.user if surgery_material.user
  end

  def action_links
	rechazar_path = rechazar_agreement_surgeries_surgery_request_path(surgery_material)
  	content_tag :div do
      concat(link_to_show [surgery_material])
  	  concat(link_to_edit [:edit, surgery_material])
  	end
  end

  def minimum_price 
    surgery_material.minimum_price  
  end

  def maximum_price 
    surgery_material.maximum_price
  end

  def price_for_audits(price)
    price
  end
end
