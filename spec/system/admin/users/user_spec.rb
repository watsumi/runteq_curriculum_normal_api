require 'rails_helper'

RSpec.describe '管理画面/ユーザー', type: :system do
  let(:general1) { create(:user, :general, created_at: DateTime.new(2019, 1, 1))}
  let(:general2) { create(:user, :general, created_at: DateTime.new(2019, 1, 2))}
  let(:general3) { create(:user, :general, created_at: DateTime.new(2019, 1, 3))}
  let(:admin) { create(:user, :admin, created_at: DateTime.new(2019, 1, 4))}

  before do
    login_as_admin
    general1
    general2
    general3
    admin

    click_on 'ユーザー一覧'
  end
  describe 'ユーザー一覧' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content 'ユーザー一覧'
      expect(find('.nav-link.active')).not_to have_content '掲示板一覧'
    end
    it 'ユーザーが一覧表示されること' do
      users = [general1, general2, general3, admin]
      users.each do |user|
        # withinでスコープ切った方がベター
        expect(page).to have_content user.id
        expect(page).to have_content user.decorate.full_name
        expect(page).to have_content user.role_i18n
        expect(page).to have_content I18n.l(user.created_at, format: :long)
      end
    end

    it '名前での検索が機能すること' do
      # 各ユーザー名前を指定してcreateしたほうがより正確なスペックになるが一旦妥協
      fill_in 'q_first_name_or_last_name_cont', with: general1.first_name
      click_on '検索'
      expect(page).to have_content general1.id
    end

    it '権限での検索が機能すること' do
      # 各ユーザー名前を指定してcreateしたほうがより正確なスペックになるが一旦妥協
      select '管理者', from: 'q_role_eq'
      click_on '検索'
      expect(page).to have_content admin.id
      expect(page).not_to have_content general1.id
      expect(page).not_to have_content general2.id
      expect(page).not_to have_content general3.id
    end
  end

  describe 'ユーザー詳細' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content 'ユーザー一覧'
      expect(find('.nav-link.active')).not_to have_content '掲示板一覧'
    end
    it 'ユーザーの詳細情報が表示されること' do
      click_on general1.decorate.full_name
      expect(current_path).to eq admin_user_path(general1)
      expect(page).to have_content general1.id
      expect(page).to have_content general1.role_i18n
      expect(page).to have_content general1.decorate.full_name
      expect(page).to have_content I18n.l(general1.created_at, format: :long)
    end
  end

  describe 'ユーザー編集' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content 'ユーザー一覧'
      expect(find('.nav-link.active')).not_to have_content '掲示板一覧'
    end
    it 'ユーザーが編集できること' do
      visit admin_user_path(general1)
      click_on '編集'
      expect(current_path).to eq edit_admin_user_path(general1)
      fill_in '姓', with: '変更後姓'
      fill_in '名', with: '変更後名'
      click_on '更新する'
      expect(current_path).to eq admin_user_path(general1)
      expect(page).to have_content 'ユーザーを更新しました'
      expect(page).to have_content '変更後姓 変更後名'
    end
  end

  describe 'ユーザー削除' do
    it 'ユーザーを削除できること' do
      visit admin_user_path(general1)
      page.accept_confirm { click_on '削除' }
      expect(current_path).to eq admin_users_path
      expect(page).to have_content 'ユーザーを削除しました'
    end
  end
end
