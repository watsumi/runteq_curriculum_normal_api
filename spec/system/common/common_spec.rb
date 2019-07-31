require 'rails_helper'

RSpec.describe '共通系', type: :system do
  context 'ログイン前' do
    before do
      visit root_path
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること' do
        expect(page).to have_content 'ログイン'
      end
    end

    describe 'フッター' do
      it 'フッターが正しく表示されていること' do
        expect(page).to have_content 'Copyright © 2019. RUNTEQ'
      end
    end
  end

  context 'ログイン後' do
    before do
      login_as_general
      visit root_path
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること', js: true do
        expect(page).to have_content '掲示板'
        expect(page).to have_content 'ブックマーク一覧'

        click_on('掲示板')
        expect(page).to have_content '掲示板一覧'
        expect(page).to have_content '掲示板作成'

        find('#header-profile').click
        login_user = User.first
        # expect(page).to have_content "#{login_user.last_name} #{login_user.first_name}"
        expect(page).to have_content 'プロフィール'
        expect(page).to have_content 'ログアウト'
      end
    end
  end
end
