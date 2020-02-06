require 'rails_helper'

RSpec.describe 'Facebookログイン', type: :system do

  describe 'ログインページ' do
    it 'Facebookログインボタンが存在すること' do
      visit login_path
      expect(page).to have_content('Facebookログイン'), '「Facebookログイン」というテキストを持ったボタンが存在しません'
    end
  end

  describe 'ユーザー登録ページ' do
    it 'Facebookログインボタンが存在すること' do
      visit new_user_path
      expect(page).to have_content('Facebookログイン'), '「Facebookログイン」というテキストを持ったボタンが存在しません'
    end
  end
end
