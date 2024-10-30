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
class FormSubmission < ApplicationRecord
  belongs_to :form

  validates :submission_data, presence: true
  validates :qrcode_id, presence: true, uniqueness: true

  before_validation :generate_qrcode_id

  private

  def generate_qrcode_id
    Rails.logger.info 'Generating QR Code ID'
    self.qrcode_id ||= SecureRandom.uuid
  end
end
