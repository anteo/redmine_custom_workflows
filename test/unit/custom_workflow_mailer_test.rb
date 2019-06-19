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

require File.expand_path('../../test_helper', __FILE__)

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
    CustomWorkflowMailer.deliver_custom_email @user2, 'Subject', 'Body'
    email = last_email
    assert text_part(email).body.include? 'Body'
    assert html_part(email).body.include? 'Body'
  end

  private

  def last_email
    mail = ActionMailer::Base.deliveries.last
    assert_not_nil mail
    mail
  end

  def text_part(email)
    email.parts.detect { |part| part.content_type.include?('text/plain') }
  end

  def html_part(email)
    email.parts.detect { |part| part.content_type.include?('text/html') }
  end

end