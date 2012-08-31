if Redmine::VERSION::MAJOR >= 2
  RedmineApp::Application.routes.draw do
    resources :custom_workflows
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :custom_workflows
  end
end
