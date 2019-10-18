require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do

  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      visit new_user_path
      fill_in 'Last name', with: 'らんてっく'
      fill_in 'First name', with: 'たろう'
      fill_in 'Email', with: 'example@example.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button '登録'
      expect(current_path).to eq root_path
      # expect(current_path).to eq boards_path
      # expect(page).to have_content 'ログインしました'
    end
  end

  context '入力情報異常系' do
    it 'ユーザーが新規作成できない' do
      visit new_user_path
      fill_in 'Email', with: 'example@example.com'
      click_button '登録'
      expect(current_path).to eq '/users'
      # expect(current_path).to eq boards_path
      # expect(page).to have_content 'ログインしました'
    end
  end
end
