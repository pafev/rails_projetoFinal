class Api::V1::PurchasesController < ApplicationController
    acts_as_token_authentication_handler_for User

    def index
        # cart = current_user.cart
        cart = Cart.find_by(user_id: current_user.id)
        # purchases = cart.purchases
        purchases = Purchase.all.select { |purchase| purchase.cart_id == cart.id }
        render json: purchases, status: :ok
    rescue StandardError => e
        render json: e, status: :bad_request
    end

    def show
        purchase = Purchase.find(params[:id])
        render json: purchase, status: :ok
    rescue StandardError => e
        render json: e, status: :not_found
    end

    def create
        cart = Cart.find_by(user_id: current_user.id)
        purchase = Purchase.new(product_id: purchase_params_create[:product_id], cart_id: cart.id,
                                quantity: purchase_params_create[:quantity])
        purchase.save!
        render json: purchase, status: :created
    rescue StandardError => e
        render json: e, status: :bad_request
    end

    def delete
        purchase = Purchase.find(params[:id])
        user_cart = Cart.find_by(user_id: current_user.id)
        if purchase.cart_id == user_cart.id
            purchase.destroy!
            render json: purchase, status: :ok
        else
            head(:bad_request)
        end
    rescue StandardError => e
        render json: e, status: :bad_request
    end

    private
    def purchase_params_create
        object = params.require(:purchase).permit(:product_id, :quantity)
    end
end
