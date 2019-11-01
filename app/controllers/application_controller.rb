class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :render_500

  add_flash_types :success, :info, :warning, :danger
  before_action :require_login

  private

  def not_authenticated
    flash[:warning] = t('defaults.message.require_login')
    redirect_to login_path
  end

  def render_500(e)
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
    render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
  end
end
