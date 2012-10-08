class WorkflowError < StandardError
  attr_accessor :error
  def initialize(message)
    @error = message.dup
    super message
  end
end

class CustomWorkflow < ActiveRecord::Base
  unloadable

  has_and_belongs_to_many :projects
  acts_as_list

  default_scope :order => 'position ASC'
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validate :validate_syntax

  if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new("3.1.0")
    named_scope :for_all, :conditions => {:is_for_all => true}
  else
    scope :for_all, where(:is_for_all => true)
  end

  def validate_syntax
    issue = Issue.new
    issue.send :instance_variable_set, :@issue, issue # compatibility with 0.0.1
    begin
      issue.instance_eval(before_save) if respond_to?(:before_save) && before_save
    rescue WorkflowError => e
    rescue Exception => e
      errors.add :before_save, :invalid_script, :error => e
    end
    begin
      issue.instance_eval(after_save) if respond_to?(:after_save) && after_save
    rescue WorkflowError => e
    rescue Exception => e
      errors.add :after_save, :invalid_script, :error => e
    end
  end

  def <=>(other)
    self.position <=> other.position
  end

  def to_s
    name
  end
end
