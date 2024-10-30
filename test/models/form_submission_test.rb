# == Schema Information
#
# Table name: form_submissions
#
#  id              :uuid             not null, primary key
#  form_id         :uuid             not null
#  submission_data :jsonb            not null
#  qrcode_id       :uuid             not null
#  checked_in      :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'test_helper'

class FormSubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
