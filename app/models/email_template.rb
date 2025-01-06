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
class EmailTemplate < ApplicationRecord
  belongs_to :form

  validates :name, presence: true
  validates :subject, presence: true
  validates :html_content, presence: true
  validates :placeholders, presence: true

  validate :form_email_enabled

  private

  def form_email_enabled
    return if form&.email_enabled?

    errors.add(:base, '此表單未啟用郵件功能')
  end
end
