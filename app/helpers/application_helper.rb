module ApplicationHelper
  def page_title(page_title = '', admin = false)
    base_title = if admin
                   'RUNTEQ BOARD APP(管理画面)'
                 else
                   'RUNTEQ BOARD APP'
                 end

    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def active_if(*current_controllers)
    'active' if active_menu?(*current_controllers)
  end

  def active_menu?(*current_controllers)
    current_controllers.any? { |c| c == controller_path }
  end
end
