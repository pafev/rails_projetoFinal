require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let(:user) {create(:user, email: "batata@batata")}
  let(:authentication_params) {{
    'X-User-Email': user.email,
    'X-User-Token': user.authentication_token
  }}
  
  let(:user_admin) {create(:user, :admin, email: "admin@batata")}
  let(:authentication_params_admin) {{
    'X-User-Email': user_admin.email, 
    'X-User-Token': user_admin.authentication_token
    }
  }

  describe "GET /index" do
    before do
      # create(:brand, id: 1)
      # create(:category, id: 1)
      # create(:product, id: 1, name: 'Galaxy A12', brand_id: 1, category_id: 1)
      # create(:product, id: 2, name: 'Moto G10', brand_id: 1, category_id: 1)
      get "/api/v1/products/index"
    end
    context "return http status ok" do
      it {expect(response).to have_http_status(:ok)}
    end
    context "return a json" do
      it {expect(response.content_type).to eq('application/json; charset=utf-8')}
    end
    # context "return the created instances" do
    #   it {expect(response.body).to eq()}
    # end
  end

  describe "GET /show" do
    let(:product) {create(:product)}
    context "id exists" do
      before do
        get "/api/v1/products/show/#{product.id}"
      end
      it "return http status ok" do
        expect(response).to have_http_status(:ok)
      end
      it "return a json" do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      # it "return the correct instance" do
      #   expect(response.body).to eq()
      # end
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
    let(:product_params) {
      {
        name: "iae",
        price: 1,
        stock_quantity: 1,
        brand_id: brand.id,
        category_id: category.id
      }
    }
    context "params are ok and user is admin" do
      it "return http status created" do
        post "/api/v1/products/create", params: {product: product_params}, headers: authentication_params_admin
        expect(response).to have_http_status(:created)
      end
    end

    context "params are ok, but user isn't admin" do
      it "return http status unauthorized" do
        post "/api/v1/products/create", params: {product: product_params}, headers: authentication_params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "params aren't ok" do
      it "return http status bad_request" do
        post "/api/v1/products/create", params: {product: nil}, headers: authentication_params_admin
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "PATCH /update" do
    let(:product) {create(:product)}
    let(:product_params) {{product: {name: "McLaren", price: 100000000, stock_quantity: 1}}}
    context "id exists and params are ok" do
      it "return http status ok" do
        patch "/api/v1/products/update/#{product.id}", params: product_params, headers: authentication_params_admin
        expect(response).to have_http_status(:ok)
      end
    end
    
    context "id exists and params aren't ok" do
      it "return http status bad_request" do
        patch "/api/v1/products/update/#{product.id}", params: nil, headers: authentication_params_admin
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "id doesn't exist" do
      it "return http status bad_request" do
        patch "/api/v1/products/update/-1", params: product_params, headers: authentication_params_admin
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "user isn't admin" do
      it "return http status unauthorized" do
        patch "/api/v1/products/update/#{product.id}", params: product_params, headers: authentication_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /delete" do
    let(:product) {create(:product)}
    context "id exists" do
      before do
        delete "/api/v1/products/delete/#{product.id}", headers: authentication_params_admin
      end
      it "return http status ok" do
        expect(response).to have_http_status(:ok)
      end
      it "remove correctly the instance" do
        get "/api/v1/products/show/#{product.id}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "id doesn't exist" do
      it "return http status not_found" do
        delete "/api/v1/products/delete/-1", headers: authentication_params_admin
        expect(response).to have_http_status(:not_found)
      end
    end

    context "user isn't admin" do
      it "return http status unauthorized" do
        delete "/api/v1/products/delete/#{product.id}", headers: authentication_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
