# == Schema Information
#
# Table name: email_templates
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  subject      :string           not null
#  html_content :text             not null
#  placeholders :jsonb            not null
#  is_active    :boolean          default(TRUE)
#  form_id      :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class EmailTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
