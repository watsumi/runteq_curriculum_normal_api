require 'rails_helper'

RSpec.describe 'コメント', type: :system do
  let(:me) { create(:user) }
  let(:board) { create(:board) }
  let(:comment_by_me) { create(:comment, user: me, board: board) }
  let(:comment_by_others) { create(:comment, board: board) }

  describe 'コメントのCRUD' do
    before do
      comment_by_me
      comment_by_others
    end
    describe 'コメントの一覧' do
      it 'コメントの一覧が表示されること' do
        login_as_user me
        visit board_path board
        within('#js-table-comment') do
          expect(page).to have_content(comment_by_me.body), 'コメントの本文が表示されていません'
          expect(page).to have_content(comment_by_me.user.decorate.full_name), 'コメントの投稿者のフルネームが表示されていません'
        end
      end
    end

    describe 'コメントの作成' do
      it 'コメントを作成できること', js: true do
        login_as_user me
        visit board_path board
        # within('#new_comment') do
          fill_in 'コメント', with: '新規コメント'
          click_on '投稿'
        # end
        sleep 0.1 # sleepしないとテストが通らない
        comment = Comment.last
        within("#comment-#{comment.id}") do
          expect(page).to have_content(me.decorate.full_name), '新規作成したコメントの投稿者のフルネームが表示されていません'
          expect(page).to have_content('新規コメント'), '新規作成したコメントの本文が表示されていません'
        end
      end
      it 'コメントの作成に失敗すること', js: true do
        login_as_user me
        visit board_path board
        # within('#new_comment') do
          fill_in 'コメント', with: ''
          click_on '投稿'
        # end
        expect(page).to have_content('コメントを入力してください'), 'コメントを空で投稿した際、エラーメッセージ「コメントを入力してください」が表示されていません'
      end
    end

    describe 'コメントの編集' do
      context '自分のコメントの場合' do
        it 'コメントを編集できること', js: true do
          login_as_user me
          visit board_path board
          within("#comment-#{comment_by_me.id}") do
            find('.js-edit-comment-button').click
            fill_in ("js-textarea-comment-#{comment_by_me.id}"), with: '編集後コメント'
            click_on '更新'
            expect(page).to have_content('編集後コメント'), 'コメントを編集した際、編集後のコメントが表示されていません'
          end
        end
        it 'コメントの編集に失敗すること', js: true do
          login_as_user me
          visit board_path board
          within("#comment-#{comment_by_me.id}") do
            find('.js-edit-comment-button').click
            fill_in ("js-textarea-comment-#{comment_by_me.id}"), with: ''
            click_on '更新'
            expect(page).to have_content('コメントを入力してください'), 'コメントを空で編集した際、エラーメッセージ「コメントを入力してください」が表示されていません'
          end
        end
      end

      context '他人のコメントの場合' do
        it '編集ボタン・削除ボタンが表示されないこと' do
          login_as_user me
          visit board_path board
          within("#comment-#{comment_by_others.id}") do
            expect(page).not_to have_selector('.js-edit-comment-button'), '他人のコメントに対して編集ボタンが表示されてしまっています'
            expect(page).not_to have_selector('.js-delete-comment-button'), '他人のコメントに対して削除ボタンが表示されてしまっています'
          end
        end
      end
    end

    describe 'コメントの削除' do
      it 'コメントを削除できること' do
        login_as_user me
        visit board_path board
        within("#comment-#{comment_by_me.id}") do
          page.accept_confirm { find('.js-delete-comment-button').click }
        end
        expect(page).not_to have_content(comment_by_me.body), 'コメントの削除が正しく機能していません'
      end
    end
  end
end
