require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  describe "GET /index" do
    before do
      create(:brand, id: 1)
      create(:category, id: 1)
      create(:product, name: 'Galaxy A12', brand_id: 1, category_id: 1)
      create(:product, name: 'Moto G10', brand_id: 1, category_id: 1)
      get "/api/v1/products/index"
    end
    context "return http status ok" do
      it {expect(response).to have_http_status(:ok)}
    end
    context "return a json" do
      it {expect(response.content_type).to eq('application/json; charset=utf-8')}
    end
    context "return the created instances" do
      it {expect(response.body).to eq(Product.all.to_json)}
    end
  end
end
