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

require 'mailer'

# Custom workflow mailer model
class CustomWorkflowMailer < Mailer
  layout 'mailer'

  def self.deliver_custom_email(user, headers = {})
    custom_email(user, headers, headers.dup).deliver_later
  end

  def custom_email(user, headers, cw_headers)
    headers[:to] ||= user.mail
    text_body = cw_headers[:text_body]
    html_body = cw_headers[:html_body]
    template_name = cw_headers[:template_name]
    template_params = cw_headers[:template_params] || {}
    if text_body || html_body
      mail headers do |format|
        format.text { render plain: text_body } if text_body.present?
        format.html { render plain: html_body } if html_body.present? && !Setting.plain_text_mail?
      end
    elsif template_name
      template_params.each { |k, v| instance_variable_set("@#{k}", v) }
      mail headers do |format|
        format.text { render template_name }
        format.html { render template_name } unless Setting.plain_text_mail?
      end
    else
      raise 'Not :text_body, :html_body or :template_name specified'
    end
  end
end
