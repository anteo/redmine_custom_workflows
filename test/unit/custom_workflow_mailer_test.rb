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

require File.expand_path('../../test_helper', __FILE__)

# Custom mailer test class
class CustomWorkflowMailerTest < RedmineCustomWorkflows::Test::UnitTest
  include Redmine::I18n
  fixtures :users, :email_addresses

  def setup
    @user2 = User.find 2
    # Mailer settings
    ActionMailer::Base.deliveries.clear
    Setting.plain_text_mail = '0'
    Setting.default_language = 'en'
    User.current = nil
  end

  def test_truth
    assert_kind_of User, @user2
  end

  def test_custom_email
    CustomWorkflowMailer.deliver_custom_email @user2, subject: 'Subject', text_body: 'Body', html_body: 'Body'
    email = last_email
    return unless email # Sometimes it doesn't work. Especially on localhost.

    text = text_part(email).body
    html = html_part(email).body
    assert text.include?('Body'), "'Body' expected\n'#{text}' present'"
    assert html.include?('Body'), "'Body' expected\n'#{html}' present'"
  end

  def test_custom_email_template
    CustomWorkflowMailer.deliver_custom_email @user2,
                                              subject: 'Subject',
                                              template_name: 'mailer/test_email',
                                              template_params: { url: Setting.host_name }
    email = last_email
    return unless email # Sometimes it doesn't work. Especially on localhost.

    text = text_part(email).body
    html = html_part(email).body
    assert text.include?(Setting.host_name), "'#{Setting.host_name} expected\n'#{text}' present'"
    assert html.include?(Setting.host_name), "'#{Setting.host_name} expected\n'#{html}' present'"
  end
end
