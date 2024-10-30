# == Schema Information
#
# Table name: forms
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  structure   :jsonb            not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class FormTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
