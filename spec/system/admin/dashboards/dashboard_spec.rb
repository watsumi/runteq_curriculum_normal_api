require 'rails_helper'

RSpec.describe '管理画面/ダッシュボード', type: :system do
  describe '権限によるアクセス制御' do
    context '一般ユーザーの場合' do
      it 'アクセスできないこと' do
        login_as_general
        visit admin_root_path
        expect(current_path).to eq root_path
        expect(page).to have_content '権限がありません'
      end
    end

    context '管理者の場合' do
      it 'アクセスできること' do
        login_as_admin
        visit admin_root_path
        expect(current_path).to eq admin_root_path
        expect(page).to have_content 'ダッシュボードです'
      end
    end
  end
end
