require 'rails_helper'

RSpec.describe '共通系', type: :system do
  describe 'ヘッダーフッター' do
    context 'ログイン前' do
      before do
        visit root_path
      end
      describe 'ヘッダー' do
        it 'ヘッダーが正しく表示されていること' do
          expect(page).to have_content('ログイン'), 'ヘッダーに「ログイン」というテキストが表示されていません'
        end
      end

      describe 'フッター' do
        it 'フッターが正しく表示されていること' do
          expect(page).to have_content('Copyright'), '「Copyright」というテキストが表示されていません'
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
          expect(page).to have_content('掲示板'), 'ヘッダーに「掲示板」というテキストが表示されていません'
          click_on('掲示板')
          expect(page).to have_content('掲示板一覧'), 'ヘッダーに「掲示板一覧」というテキストが表示されていません'
          expect(page).to have_content('掲示板作成'), 'ヘッダーに「掲示板作成」というテキストが表示されていません'

          expect(page).to have_content('ブックマーク一覧'), 'ヘッダーに「ブックマーク一覧」というテキストが表示されていません'

          find('#header-profile').click
          expect(page).to have_content("#{user.last_name} #{user.first_name}"), 'ヘッダーに「姓 名」が表示されていません'
          expect(page).to have_content('プロフィール'), 'ヘッダーに「プロフィール」というテキストが表示されていません'
          expect(page).to have_content('ログアウト'), 'ヘッダーに「ログアウト」というテキストが表示されていません'
        end
      end
    end
  end

  describe 'タイトル' do
    context 'ログイン前画面' do
      describe 'トップページ' do
        it '正しいタイトルが表示されていること' do
          visit root_path
          expect(page).to have_title('RUNTEQ BOARD APP'), 'トップページのタイトルが「RUNTEQ BOARD APP」ではありません'
        end
      end

      describe 'ログインページ' do
        it '正しいタイトルが表示されていること' do
          visit login_path
          expect(page).to have_title('ログイン | RUNTEQ BOARD APP'), 'ログインページのタイトルが「ログイン | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe 'ユーザー登録ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_user_path
          expect(page).to have_title('ユーザー登録 | RUNTEQ BOARD APP'), 'ユーザー登録ページのタイトルが「ユーザー登録 | RUNTEQ BOARD APP」ではありません'
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
          expect(page).to have_title('掲示板作成 | RUNTEQ BOARD APP'), '掲示板作成ページのタイトルが「掲示板作成 | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe '掲示板一覧ページ' do
        it '正しいタイトルが表示されていること' do
          visit boards_path
          expect(page).to have_title('掲示板一覧 | RUNTEQ BOARD APP'), '掲示板一覧ページのタイトルが「掲示板一覧 | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe '掲示板詳細ページ' do
        it '正しいタイトルが表示されていること' do
          board = create(:board)
          visit board_path(board)
          expect(page).to have_title("#{board.title} | RUNTEQ BOARD APP"), '掲示板詳細ページのタイトルが「掲示板のタイトル | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe 'プロフィールページ' do
        it '正しいタイトルが表示されていること' do
          visit profile_path
          expect(page).to have_title('プロフィール | RUNTEQ BOARD APP'), 'プロフィールページのタイトルが「プロフィール | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe 'プロフィール編集ページ' do
        it '正しいタイトルが表示されていること' do
          visit edit_profile_path
          expect(page).to have_title('プロフィール編集 | RUNTEQ BOARD APP'), 'プロフィールページのタイトルが「プロフィール編集 | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe 'パスワードリセット申請ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_password_reset_path
          expect(page).to have_title('パスワードリセット申請 | RUNTEQ BOARD APP'), 'パスワードリセット申請ページのタイトルが「パスワードリセット申請 | RUNTEQ BOARD APP」ではありません'
        end
      end

      describe 'パスワードリセットページ' do
        it '正しいタイトルが表示されていること' do
          user = create(:user)
          user.generate_reset_password_token!
          visit edit_password_reset_url(user.reset_password_token)
          expect(page).to have_title('パスワードリセット | RUNTEQ BOARD APP'), 'パスワードリセットページのタイトルが「パスワードリセット | RUNTEQ BOARD APP」ではありません'
        end
      end
    end

    context 'アドミン系画面' do
      context 'ログイン前画面' do
        describe 'ログインページ' do
          it '正しいタイトルが表示されていること' do
            visit admin_login_path
            expect(page).to have_title('ログイン | RUNTEQ BOARD APP(管理画面)'), '管理画面のログインページのタイトルが「ログイン | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end
      end

      context 'ログイン後画面' do
        before do
          login_as_admin
        end
        describe 'ダッシュボード' do
          it '正しいタイトルが表示されていること' do
            visit admin_root_path
            expect(page).to have_title('ダッシュボード | RUNTEQ BOARD APP(管理画面)'), '管理画面のダッシュボードのタイトルが「ダッシュボード | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end

        describe '掲示板一覧' do
          it '正しいタイトルが表示されていること' do
            visit admin_boards_path
            expect(page).to have_title('掲示板一覧 | RUNTEQ BOARD APP(管理画面)'), '管理画面の掲示板一覧画面のタイトルが「掲示板一覧 | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end

        describe '掲示板詳細' do
          it '正しいタイトルが表示されていること' do
            board = create(:board)
            visit admin_board_path(board)
            expect(page).to have_title('掲示板詳細 | RUNTEQ BOARD APP(管理画面)'), '管理画面の掲示板詳細画面のタイトルが「掲示板詳細 | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end

        describe '掲示板編集' do
          it '正しいタイトルが表示されていること' do
            board = create(:board)
            visit edit_admin_board_path(board)
            expect(page).to have_title('掲示板編集 | RUNTEQ BOARD APP(管理画面)'), '管理画面の掲示板編集画面のタイトルが「掲示板編集 | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end

        describe 'ユーザー一覧' do
          it '正しいタイトルが表示されていること' do
            visit admin_users_path
            expect(page).to have_title('ユーザー一覧 | RUNTEQ BOARD APP(管理画面)'), '管理画面のユーザー一覧画面のタイトルが「ユーザー一覧 | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end

        describe 'ユーザー詳細' do
          it '正しいタイトルが表示されていること' do
            user = create(:user)
            visit admin_user_path(user)
            expect(page).to have_title('ユーザー詳細 | RUNTEQ BOARD APP(管理画面)'), '管理画面のユーザー詳細画面のタイトルが「ユーザー詳細 | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end

        describe 'ユーザー編集' do
          it '正しいタイトルが表示されていること' do
            user = create(:user)
            visit edit_admin_user_path(user)
            expect(page).to have_title('ユーザー編集 | RUNTEQ BOARD APP(管理画面)'), '管理画面のユーザー編集画面のタイトルが「ユーザー編集 | RUNTEQ BOARD APP(管理画面)」ではありません'
          end
        end
      end
    end
  end
end
