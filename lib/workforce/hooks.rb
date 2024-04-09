module Workforce
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_after_save(context = {})
      RequestStore.store[:notify_workforce] = true
    end

    def controller_issues_edit_after_save(context = {})
      RequestStore.store[:notify_workforce] = true
    end
  end
end
