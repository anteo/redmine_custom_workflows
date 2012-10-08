class CustomWorkflowsController < ApplicationController
  unloadable

  layout 'admin'
  before_filter :require_admin
  before_filter :find_workflow, :only => [:show, :edit, :update, :destroy]

  def index
    @workflows = CustomWorkflow.find(:all, :include => [:projects])
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to edit_custom_workflow_path }
    end
  end

  def edit
  end

  def new
    @workflow = CustomWorkflow.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @workflow = CustomWorkflow.new(params[:custom_workflow])
    respond_to do |format|
      if @workflow.save
        flash[:notice] = l(:notice_successful_create)
        format.html { redirect_to(custom_workflows_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @workflow.update_attributes(params[:custom_workflow])
        flash[:notice] = l(:notice_successful_update)
        format.html { redirect_to(custom_workflows_path) }
      else
        format.html { render :action => :edit }
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

end
