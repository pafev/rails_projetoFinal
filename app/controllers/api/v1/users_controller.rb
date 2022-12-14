class Api::V1::UsersController < ApplicationController
    acts_as_token_authentication_handler_for User, only: [:logout, :index, :update, :show, :add_picture]
    before_action :authentication_admin, only: [:index]

    def index
        users = User.all
        render json: users, status: :ok
    end

    def show
        render json: current_user, status: :ok
    end

    def create
        user = User.new(user_params)
        user.save!
        cart = Cart.new(user_id: user.id)
        cart.save!
        render json: user, status: :created
    rescue StandardError => e
        render json: e, status: :bad_request
    end

    def update
        current_user.update!(user_params_update)
        render json: current_user, status: :ok
    rescue StandardError => e
        render json: e, status: :bad_request
    end

    def add_picture
        if current_user.profile_picture.attached?
            current_user.profile_picture.purge
        end
        params[:profile_picture].each do |profile_picture|
            current_user.profile_picture.attach(profile_picture)
        end
        render json: current_user, status: :ok
    end

    def login   
        user = User.find_by!(email: params[:email])
        if user.valid_password?(params[:password])

           render json: user, serializer: SessionSerializer, status: :ok
        else
            head(:unauthorized)
        end
    rescue StandardError => e
        render json: e, status: :unauthorized
    end
    
    def logout
        current_user.authentication_token = nil
        current_user.save!
        render json: {message: "Usuário #{current_user.name} (#{current_user.email}) deslogado com sucesso"}, status: :ok
    rescue StandardError => e
        render json: e, status: :bad_request
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :is_admin, :authentication_token, :credit_wallet, :profile_picture)
    end
    def user_params_update
        params.require(:user).permit(:name, :credit_wallet, :profile_picture)
    end
end
