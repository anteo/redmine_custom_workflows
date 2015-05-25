if Redmine::VERSION::MAJOR >= 2
  RedmineApp::Application.routes.draw do
    post '/custom_workflows/import', :to => 'custom_workflows#import', :as => 'import_custom_workflow'
    resources :custom_workflows
    post '/custom_workflows/:id', :to => 'custom_workflows#update'
    get '/custom_workflows/:id/export', :to => 'custom_workflows#export', :as => 'export_custom_workflow'
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.import_custom_workflow '/custom_workflows/import', :controller => 'custom_workflows', :action => 'import', :conditions => { :method => :post }
    map.resources :custom_workflows
    map.connect '/custom_workflows/:id', :controller => 'custom_workflows', :action => 'update', :conditions => { :method => :post }
    map.export_custom_workflow '/custom_workflows/:id/export', :controller => 'custom_workflows', :action => 'export', :conditions => { :method => :get }
  end
end
