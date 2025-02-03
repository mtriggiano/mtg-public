require 'rails_helper'

RSpec.describe "SurgeryRequestDetails", type: :request do
  describe "GET /surgery_request:references" do
    it "returns http success" do
      get "/surgery_request_detail/surgery_request:references"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /surgery_material:references" do
    it "returns http success" do
      get "/surgery_request_detail/surgery_material:references"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /material_description:string" do
    it "returns http success" do
      get "/surgery_request_detail/material_description:string"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /material_price:decimal" do
    it "returns http success" do
      get "/surgery_request_detail/material_price:decimal"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /quantity:float" do
    it "returns http success" do
      get "/surgery_request_detail/quantity:float"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /total:decimal" do
    it "returns http success" do
      get "/surgery_request_detail/total:decimal"
      expect(response).to have_http_status(:success)
    end
  end

end
