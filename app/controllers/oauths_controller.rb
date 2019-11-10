class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, success: t('defaults.message.outh_login.success', provider: provider.titleize)
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, success: t('defaults.message.outh_login.success', provider: provider.titleize)
      rescue
        redirect_to root_path, danger: t('defaults.message.outh_login.fail', provider: provider.titleize)
      end
    end
  end
end
