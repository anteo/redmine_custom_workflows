# frozen_string_literal: true

# Redmine plugin for Custom Workflows
#
# Anton Argirov, Karel Pičman <karel.picman@kontron.com>
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

# Custom workflows controller
class CustomWorkflowsController < ApplicationController
  layout 'admin'
  before_action :require_admin
  before_action :find_workflow, only: %i[show edit update destroy export change_status reorder]

  def reorder
    from = @workflow.position
    to = params[:custom_workflow][:position].to_i
    CustomWorkflow.transaction do
      CustomWorkflow.find_each do |wf|
        if wf.position == from
          wf.position = to
        elsif wf.position >= to && wf.position < from
          # Move up
          wf.position = wf.position + 1
        elsif wf.position <= to && wf.position > from
          # Move down
          wf.position = wf.position - 1
        end
        wf.save
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @workflows = CustomWorkflow.includes(:projects).order(position: :asc)
    respond_to do |format|
      format.html
    end
  end

  def export
    send_data @workflow.export_as_xml, filename: "#{@workflow.name}.xml", type: :xml
  end

  def show
    respond_to do |format|
      format.html { redirect_to edit_custom_workflow_path }
    end
  end

  def new
    @workflow = CustomWorkflow.new
    @workflow.author = cookies[:custom_workflows_author]
    respond_to do |format|
      format.html
    end
  end

  def edit; end

  def import
    xml = params[:file].read
    begin
      @workflow = CustomWorkflow.import_from_xml(xml)
      @workflow.active = false
      if @workflow.save
        flash[:notice] = l(:notice_successful_import)
      else
        flash[:error] = @workflow.errors.full_messages.to_sentence
      end
    rescue StandardError => e
      Rails.logger.warn "Workflow import error: #{e.message}\n #{e.backtrace.join("\n ")}"
      flash[:error] = l(:error_failed_import)
    end
    respond_to do |format|
      format.html { redirect_to(custom_workflows_path) }
    end
  end

  def create
    @workflow = CustomWorkflow.new
    @workflow.position = CustomWorkflow.count + 1
    @workflow.observable = params[:custom_workflow][:observable]
    update_from_params
    respond_to do |format|
      if params.key?(:commit) && @workflow.save
        flash[:notice] = l(:notice_successful_create)
        cookies[:custom_workflows_author] = @workflow.author
        format.html { redirect_to(custom_workflows_path) }
      else
        format.html { render action: :new }
      end
    end
  end

  def change_status
    respond_to do |format|
      if @workflow.update(active: params[:active])
        flash[:notice] = l(:notice_successful_status_change)
        format.html { redirect_to(custom_workflows_path) }
      else
        format.html { render action: :edit }
      end
    end
  end

  def update
    respond_to do |format|
      update_from_params
      if params.key?(:commit) && @workflow.save
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(custom_workflows_path) }
      else
        format.html { render action: :edit }
      end
    end
  end

  def destroy
    @workflow.destroy
    respond_to do |format|
      flash[:notice] = l(:notice_successful_delete)
      format.html { redirect_to(custom_workflows_path) }
    end
  end

  private

  def find_workflow
    @workflow = CustomWorkflow.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def update_from_params
    @workflow.before_save = params[:custom_workflow][:before_save]
    @workflow.after_save = params[:custom_workflow][:after_save]
    @workflow.name = params[:custom_workflow][:name]
    @workflow.description = params[:custom_workflow][:description]
    @workflow.is_for_all = params[:custom_workflow][:is_for_all] == '1'
    @workflow.author = params[:custom_workflow][:author]
    @workflow.active = params[:custom_workflow][:active]
    @workflow.shared_code = params[:custom_workflow][:shared_code]
    @workflow.before_add = params[:custom_workflow][:before_add]
    @workflow.after_add = params[:custom_workflow][:after_add]
    @workflow.before_remove = params[:custom_workflow][:before_remove]
    @workflow.after_remove = params[:custom_workflow][:after_remove]
    @workflow.before_destroy = params[:custom_workflow][:before_destroy]
    @workflow.after_destroy = params[:custom_workflow][:after_destroy]
    @workflow.project_ids = params[:custom_workflow][:project_ids]
  end
end
