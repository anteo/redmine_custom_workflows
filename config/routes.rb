# encoding: utf-8
#
# Redmine plugin for Custom Workflows
#
# Copyright Anton Argirov
# Copyright Karel Pičman <karel.picman@kontron.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

RedmineApp::Application.routes.draw do

  resources :custom_workflows do
    member do

    end
  end

  post '/custom_workflows/import', :to => 'custom_workflows#import', :as => 'import_custom_workflow'
  post '/custom_workflows/:id', :to => 'custom_workflows#update'
  get '/custom_workflows/:id/export', :to => 'custom_workflows#export', :as => 'export_custom_workflow'
  post '/custom_workflows/:id/change_status', :to => 'custom_workflows#change_status', :as => 'custom_workflow_status'
  put '/custom_workflows/:id/reorder', :to => 'custom_workflows#reorder'
end
