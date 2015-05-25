class CustomWorkflowsController < ApplicationController

  layout 'admin'
  before_filter :require_admin
  before_filter :find_workflow, :only => [:show, :edit, :update, :destroy, :export]

  def index
    @workflows = CustomWorkflow.includes(:projects).all
    respond_to do |format|
      format.html
    end
  end

  def export
    send_data @workflow.export_as_xml, :filename => @workflow.name + '.xml', :type => :xml
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
    @workflow.author = cookies[:custom_workflows_author]
    respond_to do |format|
      format.html
    end
  end

  def import
    xml = params[:file].read
    begin
      @workflow = CustomWorkflow.import_from_xml(xml)
      if @workflow.save
        flash[:notice] = l(:notice_successful_import)
      else
        flash[:error] = @workflow.errors.full_messages.to_sentence
      end
    rescue Exception => e
      Rails.logger.warn "Workflow import error: #{e.message}\n #{e.backtrace.join("\n ")}"
      flash[:error] = l(:error_failed_import)
    end
    respond_to do |format|
      format.html { redirect_to(custom_workflows_path) }
    end
  end

  def create
    @workflow = CustomWorkflow.new(params[:custom_workflow])
    respond_to do |format|
      if @workflow.save
        flash[:notice] = l(:notice_successful_create)
        cookies[:custom_workflows_author] = @workflow.author
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
