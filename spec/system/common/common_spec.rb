require 'rails_helper'

RSpec.describe '共通系', type: :system do
  before do
    visit root_path
  end
  describe 'ヘッダー' do
    it 'ヘッダーが正しく表示されていること' do
      expect(page).to have_content '掲示板'
      expect(page).to have_content '掲示板一覧'
      expect(page).to have_content '掲示板作成'
      expect(page).to have_content 'ブックマーク一覧'
      expect(page).to have_content 'プロフィール'
      expect(page).to have_content 'ログアウト'
    end
  end

  describe 'フッター' do
    it 'フッターが正しく表示されていること' do
      expect(page).to have_content 'Copyright © 2019. RUNTEQ'
    end
  end
end
