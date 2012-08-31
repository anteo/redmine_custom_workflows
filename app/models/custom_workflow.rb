class WorkflowError < StandardError
  attr_accessor :error
  def initialize(message)
    @error = message.dup
    super message
  end
end

class CustomWorkflow < ActiveRecord::Base
  has_and_belongs_to_many :projects
  acts_as_list

  default_scope :order => 'position ASC'
  validates_presence_of :script
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validate :validate_syntax

  def eval_script(context)
    context.each { |k, v| instance_variable_set ("@#{k}").to_sym, v }
    eval(script)
  end

  def validate_syntax
    begin
      eval_script(:issue => Issue.new)
    rescue WorkflowError => e
    rescue Exception => e
      errors.add :script, :invalid_script, :error => e
    end
  end

  def to_s
    name
  end
end
