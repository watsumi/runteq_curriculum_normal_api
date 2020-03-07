class Api::V1::BoardsController < Api::V1::BaseController
  before_action :require_login

  def index
    boards = Board.all.order(created_at: :desc)
    render json: boards
  end

  def create
    board = current_user.boards.build(board_params)
    if board.save
      render json: board
    else
      render json: board.errors, status: :bad_request
    end
  end

  private

  def board_params
    params.require(:board).permit(:title, :body)
  end
end
