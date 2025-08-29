module Workforce
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_after_save(context = {})
      RequestStore.store[:notify_workforce] = true
    end

    def controller_issues_edit_after_save(context = {})
      set_notify_flag(context)
    end

    def controller_journals_edit_post(context = {})
      set_notify_flag(context)
    end

    private

    def set_notify_flag(context)
      request = context[:request]
      return if request.nil?
      header_value = request.headers['X-Notify-Workforce'].to_s.strip.downcase
      if header_value == 'disable'
        RequestStore.store[:notify_workforce] = false
      else
        RequestStore.store[:notify_workforce] = true
      end
    end
  end
end
