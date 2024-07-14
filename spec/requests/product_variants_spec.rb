require 'rails_helper'

RSpec.describe "ProductVariants", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/product_variants/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/product_variants/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/product_variants/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
