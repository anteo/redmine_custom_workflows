module RedmineCustomWorkflows
  module MailerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
      end
    end

    module InstanceMethods
      def self.deliver_custom_email(headers={})
        user = headers.delete :user
        headers[:to] = user.mail if user
        text_body = headers.delete :text_body
        html_body = headers.delete :html_body
        template_name = headers.delete :template_name
        template_params = headers.delete(:template_params) || {}
        if text_body || html_body
          mail headers do |format|
            format.text { render :text => text_body } if text_body
            format.html { render :html => html_body } if html_body
          end
        elsif template_name
          template_params.each { |k,v| instance_variable_set("@#{k}", v) }
          mail headers do |format|
            format.text { render template_name }
            format.html { render template_name } unless Setting.plain_text_mail?
          end
        else
          raise 'Nor :text_body, :html_body or :template_name specified'
        end
      end
    end
  end
end
