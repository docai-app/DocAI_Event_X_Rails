class FormSubmission < ApplicationRecord
  belongs_to :form

  validates :submission_data, presence: true
  validates :qrcode_id, presence: true, uniqueness: true

  before_create :generate_qrcode_id

  private

  def generate_qrcode_id
    self.qrcode_id ||= SecureRandom.uuid
  end
end
