# == Schema Information
#
# Table name: forms
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  json_schema :jsonb            not null
#  ui_schema   :jsonb            not null
#  form_data   :jsonb            not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Form < ApplicationRecord
  has_many :form_submissions, dependent: :destroy

  validates :name, presence: true
  validates :json_schema, presence: true
  validates :ui_schema, presence: true
  validates :form_data, presence: true
end
