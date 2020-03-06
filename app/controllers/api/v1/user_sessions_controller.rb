class Api::V1::UserSessionsController < Api::V1::BaseController
  def create
    if user = login(params[:email], params[:password])
      render json: user
    else
      head :unauthorized
    end
  end

  def destroy
    logout
    head :ok
  end
end
