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

  describe "GET /show" do
    before do
      create(:brand, id: 1)
      create(:category, id: 1)
    end
    let(:product) {create(:product, brand_id: 1, category_id: 1)}
    context "id exists" do
      before do
        get "/api/v1/products/show/#{product.id}"
      end
      it "return http status ok" do
        expect(response).to have_http_status(:ok)
      end
      it "return the correct instance" do
        expect(response.body).to eq(product.to_json)
      end
    end
    context "id doesn't exist" do
      before do
        get "/api/v1/products/show/-1"
      end
      it "return http status not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /create" do
    let(:brand) {create(:brand)}
    let(:category) {create(:category)}
    context "params are ok" do
      it "return http status ok" do
        post "/api/v1/products/create", params: {
          product:{
            name: "iPhone 21",
            price: 9999999,
            stock_quantity: 2,
            brand_id: brand.id,
            category_id: category.id
            }
          }
        expect(response).to have_http_status(:created)
      end
    end
    context "params aren't ok" do
      it "name shouldn't be nil" do
        post "/api/v1/products/create", params: {
          product:{
            name: nil,
            price: 9999999,
            stock_quantity: 2,
            brand_id: brand.id,
            category_id: category.id
            }
          }
        expect(response).to have_http_status(:bad_request)
      end
      it "price shouldn't be nil" do
        post "/api/v1/products/create", params: {
          product:{
            name: "iPhone 21",
            price: nil,
            stock_quantity: 2,
            brand_id: brand.id,
            category_id: category.id
            }
          }
        expect(response).to have_http_status(:bad_request)
      end
      it "stock_quantity shouldn't be nil" do
        post "/api/v1/products/create", params: {
          product:{
            name: "iPhone 21",
            price: 9999999,
            stock_quantity: nil,
            brand_id: brand.id,
            category_id: category.id
            }
          }
        expect(response).to have_http_status(:bad_request)
      end
      it "name should be uniq" do
        post "/api/v1/products/create", params: {
          product:{
            name: "iPhone 21",
            price: 9999999,
            stock_quantity: 2,
            brand_id: brand.id,
            category_id: category.id
            }
          }
        post "/api/v1/products/create", params: {
          product:{
            name: "iPhone 21",
            price: 10,
            stock_quantity: 3500,
            brand_id: brand.id,
            category_id: category.id
            }
          }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
