module RedmineCustomWorkflows
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      stylesheet_link_tag :style, :plugin => 'redmine_custom_workflows'
    end
  end
end