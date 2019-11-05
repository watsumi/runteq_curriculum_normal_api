require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do

  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      visit new_user_path
      fill_in '姓', with: 'らんてっく'
      fill_in '名', with: 'たろう'
      fill_in 'メールアドレス', with: 'example@example.com'
      fill_in 'パスワード', with: '12345678'
      fill_in 'パスワード確認', with: '12345678'
      click_button '登録'
      expect(current_path).to eq login_path
      # expect(current_path).to eq boards_path
      expect(page).to have_content 'ユーザー登録が完了しました'
    end
  end

  context '入力情報異常系' do
    it 'ユーザーが新規作成できない' do
      visit new_user_path
      fill_in 'メールアドレス', with: 'example@example.com'
      click_button '登録'
      expect(current_path).to eq '/users'
      # expect(current_path).to eq boards_path
      expect(page).to have_content 'ユーザー登録に失敗しました'
      # 個別のエラーメッセージが表示されること
      expect(page).to have_content '姓を入力してください'
    end
  end
end
