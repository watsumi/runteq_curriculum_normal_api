require 'rails_helper'

RSpec.describe 'ブックマーク', type: :system do
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) }

  before do
    board
  end

  it 'ブックマークができること' do
    login_as_general
    visit boards_path
    find("#js-bookmark-button-for-board-#{board.id}").click
    expect(current_path).to eq boards_path
    expect(page).to have_content('ブックマークしました'), 'フラッシュメッセージ「ブックマークしました」が表示されていません'
  end

  it 'ブックマークを外せること' do
    login_as_general
    visit boards_path
    find("#js-bookmark-button-for-board-#{board.id}").click
    # ブックマークを外す
    find("#js-bookmark-button-for-board-#{board.id}").click
    expect(current_path).to eq boards_path
    expect(page).to have_content('ブックマークを外しました'), 'フラッシュメッセージ「ブイックマークを外しました」が表示されていません'
  end
end
