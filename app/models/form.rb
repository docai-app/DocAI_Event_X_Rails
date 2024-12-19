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
#
class Form < ApplicationRecord
  has_many :form_submissions, dependent: :destroy

  validates :name, presence: true
  validates :json_schema, presence: true
  validates :ui_schema, presence: true
  validates :form_data, presence: true
  validates :is_active, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
end
