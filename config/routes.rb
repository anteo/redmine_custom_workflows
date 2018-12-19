RedmineApp::Application.routes.draw do
  post '/custom_workflows/import', :to => 'custom_workflows#import', :as => 'import_custom_workflow'
  resources :custom_workflows
  post '/custom_workflows/:id', :to => 'custom_workflows#update'
  get '/custom_workflows/:id/export', :to => 'custom_workflows#export', :as => 'export_custom_workflow'
  post '/custom_workflows/:id/change_status', :to => 'custom_workflows#change_status', :as => 'custom_workflow_status'
  put '/custom_workflows/:id/reorder', :to => 'custom_workflows#reorder'
end
