require 'rails_helper'

describe 'Board', type: :request do
  let!(:user) { create(:user) }
  let!(:board) { create(:board) }
  before do
    login_user(user, '12345678', login_path)
  end

  it '他人の掲示板の編集画面に遷移できないこと' do
    get edit_board_path(board)
    expect(response).to have_http_status(404)
  end

  it '他人の掲示板を更新できないこと' do
    patch board_path(board)
    expect(response).to have_http_status(404)
  end

  it '他人の掲示板を削除できないこと' do
    delete board_path(board)
    expect(response).to have_http_status(404)
  end
end
