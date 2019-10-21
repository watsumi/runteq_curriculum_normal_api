require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  let(:user) { create(:user) }
  # let(:admin_user) { create(:user, :admin) }

  describe '通常画面' do
    describe 'ログイン' do
      context '認証情報が正しい場合' do
        it 'ログインできること' do
          visit login_path
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: '12345678'
          click_button 'ログイン'
          expect(current_path).to eq boards_path
          # expect(current_path).to eq boards_path
          expect(page).to have_content 'ログインしました'
        end
      end

      context 'PWに誤りがある場合' do
        it 'ログインできないこと' do
          visit login_path
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: '1234'
          click_button 'ログイン'
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end
    end

    describe 'ログアウト' do
      before do
        login_as_general
      end
      it 'ログアウトできること' do
        find('#header-profile').click
        click_on('ログアウト')
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  # describe '管理画面' do
  #   describe 'ログイン' do
  #     describe 'ログイン失敗' do
  #       context '管理者以外の場合' do
  #         it 'トップページにリダイレクトされること' do
  #           visit admin_login_path
  #           fill_in 'メールアドレス', with: general_user.email
  #           fill_in 'パスワード', with: '12345678'
  #           click_button 'ログイン'
  #           expect(current_path).to eq root_path
  #           expect(page).to have_content '権限がありません'
  #         end
  #       end
  #
  #       context '管理者の場合' do
  #         context 'PWに誤りがある場合' do
  #           it 'ログインできないこと' do
  #             visit admin_login_path
  #             fill_in 'メールアドレス', with: admin_user.email
  #             fill_in 'パスワード', with: '1234'
  #             click_button 'ログイン'
  #             expect(current_path).to eq admin_login_path
  #             expect(page).to have_content 'ログインに失敗しました'
  #           end
  #         end
  #
  #         context '認証情報が正しい場合' do
  #           it 'ログインできること' do
  #             visit admin_login_path
  #             fill_in 'メールアドレス', with: admin_user.email
  #             fill_in 'パスワード', with: '12345678'
  #             click_button 'ログイン'
  #             expect(current_path).to eq admin_root_path
  #             expect(page).to have_content 'ログインしました'
  #           end
  #         end
  #       end
  #     end
  #   end
  #
  #   describe 'ログアウト' do
  #     before do
  #       login_as_admin
  #     end
  #     it 'ログアウトできること' do
  #       click_on('ログアウト')
  #       expect(current_path).to eq admin_login_path
  #       expect(page).to have_content 'ログアウトしました'
  #     end
  #   end
  # end
end
