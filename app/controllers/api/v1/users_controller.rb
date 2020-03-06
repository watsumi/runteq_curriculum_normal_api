class Api::V1::UsersController < Api::V1::BaseController

  def create
    user = User.new(user_params)
    if user.save
      auto_login(user)
      render json: user
    else
      render json: user.errors, status: :bad_request
    end
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def me
    if current_user
      render json: current_user
    else
      head :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name)
  end
end
