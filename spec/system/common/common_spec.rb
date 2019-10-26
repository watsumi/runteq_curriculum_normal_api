require 'rails_helper'

RSpec.describe '共通系', type: :system do
  describe 'ヘッダーフッター' do
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
      let(:user) { create(:user) }
      before do
        login_as_user(user)
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
          expect(page).to have_content "#{user.last_name} #{user.first_name}"
          expect(page).to have_content 'プロフィール'
          expect(page).to have_content 'ログアウト'
        end
      end
    end
  end

  describe 'タイトル' do
    context 'ログイン前画面' do
      describe 'トップページ' do
        it '正しいタイトルが表示されていること' do
          visit root_path
          expect(page).to have_title 'RUNTEQ BOARD APP'
        end
      end

      describe 'ログインページ' do
        it '正しいタイトルが表示されていること' do
          visit login_path
          expect(page).to have_title 'ログイン | RUNTEQ BOARD APP'
        end
      end

      describe 'ユーザー登録ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_user_path
          expect(page).to have_title 'ユーザー登録 | RUNTEQ BOARD APP'
        end
      end
    end

    context 'ログイン後画面' do
      before do
        login_as_general
      end
      describe '掲示板作成ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_board_path
          expect(page).to have_title '掲示板作成 | RUNTEQ BOARD APP'
        end
      end

      describe '掲示板一覧ページ' do
        it '正しいタイトルが表示されていること' do
          visit boards_path
          expect(page).to have_title '掲示板一覧 | RUNTEQ BOARD APP'
        end
      end

      describe '掲示板詳細ページ' do
        it '正しいタイトルが表示されていること' do
          board = create(:board)
          visit board_path(board)
          expect(page).to have_title "#{board.title} | RUNTEQ BOARD APP"
        end
      end
    end
  end
end
