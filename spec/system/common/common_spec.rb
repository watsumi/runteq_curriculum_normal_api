require 'rails_helper'

RSpec.describe '共通系', type: :system do
  before do
    visit root_path
  end
  describe 'ヘッダー' do
    it 'ヘッダーが正しく表示されていること' do
      expect(page).to have_content('掲示板'), 'ヘッダーに「掲示板」というテキストが表示されていません'
      expect(page).to have_content('掲示板一覧'), 'ヘッダーに「掲示板一覧」というテキストが表示されていません'
      expect(page).to have_content('掲示板作成'), 'ヘッダーに「掲示板作成」というテキストが表示されていません'
      expect(page).to have_content('ブックマーク一覧'), 'ヘッダーに「ブックマーク一覧」というテキストが表示されていません'
      expect(page).to have_content('プロフィール'), 'ヘッダーに「プロフィール」というテキストが表示されていません'
      expect(page).to have_content('ログアウト'), 'ヘッダーに「ログアウト」というテキストが表示されていません'
    end
  end

  describe 'フッター' do
    it 'フッターが正しく表示されていること' do
      expect(page).to have_content('Copyright'), '「Copyright」というテキストが表示されていません'
    end
  end
end
