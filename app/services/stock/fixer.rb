module Stock
  class Fixer

    def initialize(day, hour)
      @products = Product.all.select{|a| a.updated_at.to_date == day && a.updated_at.hour == hour}
    end

    def call
      fix_products
    end

    private

    def fix_products
      @products.each do |product|
        product.batches.where("quantity >= 1000").where(state: true).update_all(state: false)
        article = product.articles.find_by(store_id: 3)
				product.available_stock =  product.batches.select{|b| b.state }.sum(&:quantity)
				product.articles_attributes = { 0 => {id: article&.id, store_id: 3, available: product.available_stock.to_i} }
        product.save
      end
    end

  end

end
