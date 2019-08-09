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

module RedmineCustomWorkflows
  module Patches
    module MailerPatch

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
            format.html { render :text => html_body } if html_body
          end
        elsif template_name
          template_params.each { |k,v| instance_variable_set("@#{k}", v) }
          mail headers do |format|
            format.text { render template_name }
            format.html { render template_name } unless Setting.plain_text_mail?
          end
        else
          raise 'Not :text_body, :html_body or :template_name specified'
        end
      end

    end
  end
end

RedmineExtensions::PatchManager.register_model_patch 'Mailer',
  'RedmineCustomWorkflows::Patches::MailerPatch'