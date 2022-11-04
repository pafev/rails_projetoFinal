class Api::V1::BrandsController < ApplicationController
    def index
        brands = Brand.all
        render json: brands, status: :ok
    end
    def show
        brand = Brand.find(params[:id])
        render json: brand, status: :ok
    rescue StandardError => e
        render json: e, status: :not_found
    end
    def create
        brand = Brand.new(brand_params)
        brand.save!
        render json: brand, status: :created
    rescue StandardError => e
        render json: e, status: :bad_request
    end
    def update
        brand = Brand.find(params[:id])
        brand.update!(brand_params)
        render json: brand, status: :ok
    rescue StandardError => e
        render json: e, status: :bad_request
    end
    def delete
        brand = Brand.find(params[:id])
        brand.destroy!
        render json: {message: "Marca #{brand.name} destruída com sucesso!"}, status: :ok
    rescue StandardError => e
        render json: e, status: :not_found
    end

    private
    def brand_params
        params.require(:brand).permit(:name)
    end
end
