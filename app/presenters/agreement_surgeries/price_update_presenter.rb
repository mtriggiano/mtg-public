class AgreementSurgeries::PriceUpdatePresenter < BasePresenter
  presents :price_update

  def id
  	price_update.id
  end

  def percent
  	price_update.percent
  end

  def user
    link_to price_update.created_by.email, price_update.created_by if price_update.created_by
  end

  def created_at
    price_update.created_at
  end

  def action_links
  	content_tag :div do
      concat(link_to_show [price_update])
  	end
  end

end