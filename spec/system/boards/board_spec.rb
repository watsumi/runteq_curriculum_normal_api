require 'rails_helper'

RSpec.describe '掲示板', type: :system do
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) }

  describe '掲示板のCRUD' do
    describe '掲示板の一覧' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit boards_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインしてください'
        end
      end

      context 'ログインしている場合' do
        it 'ヘッダーのリンクから掲示板一覧へ遷移できること' do
          login_as_general
          click_on('掲示板')
          click_on('掲示板一覧')
          expect(current_path).to eq boards_path
        end

        context '掲示板が一件もない場合' do
          it '何もない旨のメッセージが表示されること' do
            login_as_general
            visit boards_path
            expect(page).to have_content '掲示板がありません。'
          end
        end

        context '掲示板がある場合' do
          it '掲示板の一覧が表示されること' do
            board
            login_as_general
            visit boards_path
            expect(page).to have_content board.title
            expect(page).to have_content board.user.decorate.full_name
            expect(page).to have_content board.body
            expect(page).to have_content I18n.l(board.created_at, format: :long)
          end

          context '21件以上ある場合' do
            let!(:boards) { create_list(:board, 21) }
            it 'ページングが表示されること' do
              login_as_general
              visit boards_path
              expect(page).to have_selector('.pagination')
            end
          end
        end
      end
    end

    describe '掲示板の詳細' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit board_path(board)
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインしてください'
        end
      end

      context 'ログインしている場合' do
        before do
          board
          login_as_general
        end
        it '掲示板の詳細が表示されること' do
          visit boards_path
          within "#board-id-#{board.id}" do
            click_on board.title
          end
          expect(page).to have_content board.title
          expect(page).to have_content board.user.decorate.full_name
          expect(page).to have_content board.body
          expect(page).to have_content I18n.l(board.created_at, format: :long)
        end
      end
    end

    describe '掲示板の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit new_board_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインしてください'
        end
      end

      context 'ログインしている場合' do
        before do
          login_as_general
          click_on('掲示板')
          click_on('掲示板作成')
        end

        it '掲示板が作成できること' do
          fill_in 'タイトル', with: 'テストタイトル'
          fill_in '本文', with: 'テスト本文'
          file_path = Rails.root.join('spec', 'fixtures', 'example.jpg')
          attach_file "サムネイル", file_path
          # プレビュー機能の確認は辛い...
          click_button '登録する'
          # board = Board.last
          expect(current_path).to eq boards_path
          expect(page).to have_content '掲示板を作成しました'
          expect(page).to have_content 'テストタイトル'
          expect(page).to have_content 'テスト本文'
        end

        it '掲示板の作成に失敗すること' do
          fill_in 'タイトル', with: 'テストタイトル'
          file_path = Rails.root.join('spec', 'fixtures', 'example.txt')
          attach_file "サムネイル", file_path
          click_button '登録する'
          expect(page).to have_content '掲示板を作成できませんでした'
          # 入力した値が残っていること
          expect(page).to have_field('タイトル', with: 'テストタイトル')
          # 個別のエラーメッセージが表示されること
          expect(page).to have_content '本文を入力してください'
          # 拡張子の制限チェック
          expect(page).to have_content 'サムネイルは jpg, jpeg, gif, pngの形式でアップロードしてください'
        end
      end
    end

    describe '掲示板の更新' do
      before do
        board
      end
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit edit_board_path(board)
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインしてください'
        end
      end

      context 'ログインしている場合' do
        context '自分の掲示板' do
          before do
            login_as_user user
            visit boards_path
            find("#button-edit-#{board.id}").click
          end
          it '掲示板が更新できること' do
            fill_in 'タイトル', with: '編集後テストタイトル'
            fill_in '本文', with: '編集後テスト本文'
            click_button '更新する'
            expect(current_path).to eq board_path(board)
            expect(page).to have_content '掲示板を更新しました'
            expect(page).to have_content 'テストタイトル'
            expect(page).to have_content 'テスト本文'
          end

          it '掲示板の作成に失敗すること' do
            fill_in 'タイトル', with: '編集後テストタイトル'
            fill_in '本文', with: ''
            click_button '更新する'
            expect(page).to have_content '掲示板を更新できませんでした'
          end
        end

        context '他人の掲示板' do
          it '編集ボタンが表示されないこと' do
            login_as_general
            visit boards_path
            expect(page).not_to have_selector("#button-edit-#{board.id}")
          end
        end
      end
    end

    describe '掲示板の削除' do
      before do
        board
      end
      context '自分の掲示板' do
        it '掲示板が削除できること', js: true do
          login_as_user user
          visit boards_path
          page.accept_confirm { find("#button-delete-#{board.id}").click }
          expect(current_path).to eq boards_path
          expect(page).to have_content '掲示板を削除しました'
        end
      end

      context '他人の掲示板' do
        it '削除ボタンが表示されないこと' do
          login_as_general
          visit boards_path
          expect(page).not_to have_selector("#button-delete-#{board.id}")
        end
      end
    end

    describe '掲示板のブックマーク一覧' do
      before do
        board
      end

      context '1件もブックマークしていない場合' do
        it '1件もない旨のメッセージが表示されること' do
          login_as_general
          visit boards_path
          click_on 'ブックマーク一覧'
          expect(current_path).to eq bookmarks_boards_path
          expect(page).to have_content 'ブックマーク中の掲示板がありません'
        end
      end

      context 'ブックマークしている場合' do
        it 'ブックマークした掲示板が表示されること', js: true do
          login_as_general
          visit boards_path
          find("#js-bookmark-button-for-board-#{board.id}").click
          click_on 'ブックマーク一覧'
          expect(current_path).to eq bookmarks_boards_path
          expect(page).to have_content board.title
        end
      end

      context '21件以上ある場合' do
        let!(:boards) { create_list(:board, 21) }
        it 'ページングが表示されること' do
          boards.each do |board|
            Bookmark.create(user: user, board: board)
          end
          login_as_user user
          visit bookmarks_boards_path
          expect(page).to have_selector('.pagination')
        end
      end
    end
  end
end
