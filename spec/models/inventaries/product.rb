require 'rails_helper'
require 'byebug'
describe "Stock movements" do

  context "Stock Arrival" do
    subject { Article.new }
    before :each do
      @company = create(:company)
      @external_arrival = build(:external_arrival, company: @company, user: @user, entity: @supplier, product: @product)
      @store = @external_arrival.store
    end

    it "confirmed must create new article" do
      @external_arrival.state = "Aprobado"
      @external_arrival.save
      @external_arrival.details.each do |detail|
        article = Article.where(product_id: detail.product_id, store_id: @store.id)
        expect(article.size).to be_equal 1
      end
    end

    it "canceled must destroy article" do
      @external_arrival.state = "Aprobado"
      @external_arrival.save
      @external_arrival.state = "Anulado"
      @external_arrival.save
      pp Article.all
      expect(Article.all.size).to be_equal 0
    end
  end
end
