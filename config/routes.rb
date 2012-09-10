if Redmine::VERSION::MAJOR >= 2
  RedmineApp::Application.routes.draw do
    resources :custom_workflows
    post '/custom_workflows/:id', :to => 'custom_workflows#update'
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :custom_workflows
    map.connect '/custom_workflows/:id', :controller => 'custom_workflows', :action => 'update', :conditions => { :method => :post }
  end
end
