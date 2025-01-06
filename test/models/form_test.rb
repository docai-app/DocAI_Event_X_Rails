# frozen_string_literal: true

# == Schema Information
#
# Table name: forms
#
#  id            :uuid             not null, primary key
#  name          :string           not null
#  description   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  json_schema   :jsonb
#  ui_schema     :jsonb
#  form_data     :jsonb
#  display_order :jsonb            not null
#  is_active     :boolean          default(FALSE), not null
#  meta          :jsonb            not null
#  email_enabled :boolean          default(FALSE)
#
require 'test_helper'

class FormTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
