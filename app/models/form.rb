

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
class Form < ApplicationRecord
  has_many :form_submissions, dependent: :destroy

  validates :name, presence: true
  validates :structure, presence: true
end
