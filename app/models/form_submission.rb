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
#  confirmation_email_sent:boolean
#  confirmation_email_sent_at:datetime
#
class FormSubmission < ApplicationRecord
  belongs_to :form

  validates :submission_data, presence: true
  validates :qrcode_id, presence: true, uniqueness: true

  before_validation :generate_qrcode_id
  after_create :send_confirmation_email

  def send_confirmation_email
    return if confirmation_email_sent

    email = submission_data['email']
    if email.present?
      FormSubmissionMailer.confirmation_email(id).deliver_later
    else
      Rails.logger.warn 'No email found in submission_data'
    end
  end

  private

  def generate_qrcode_id
    Rails.logger.info 'Generating QR Code ID'
    self.qrcode_id ||= SecureRandom.uuid
  end
  
end
