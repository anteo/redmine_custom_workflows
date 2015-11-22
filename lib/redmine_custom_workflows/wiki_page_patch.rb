module RedmineCustomWorkflows
  module WikiPagePatch

    def self.included(base)
      base.send :include, InstanceMethods
      base.class_eval do
        def self.attachments_callback(event, page, attachment)
          page.instance_variable_set(:@page, page)
          page.instance_variable_set(:@attachment, attachment)
          CustomWorkflow.run_shared_code(page) if event.to_s.starts_with? 'before_'
          CustomWorkflow.run_custom_workflows(:wiki_page_attachments, page, event)
        end

        [:before_add, :before_remove, :after_add, :after_remove].each do |observable|
          send("#{observable}_for_attachments") << if Rails::VERSION::MAJOR >= 4
                                                     lambda { |event, page, attachment| WikiPage.attachments_callback(event, page, attachment) }
                                                   else
                                                     lambda { |page, attachment| WikiPage.attachments_callback(observable, page, attachment) }
                                                   end
        end
      end
    end

    module InstanceMethods
    end
  end
end
