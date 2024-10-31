class FormSubmissionMailer < ApplicationMailer
  require 'rqrcode'

  def confirmation_email(form_submission_id)
    form_submission = FormSubmission.find(form_submission_id)

    # 检查邮件是否已经发送
    return if form_submission.confirmation_email_sent

    @submission_data = form_submission.submission_data
    @qrcode = generate_qrcode(form_submission.qrcode_id)

    mail(to: @submission_data['email'], subject: "Form Submission Confirmation") do |format|
      format.html
    end

    # 邮件发送后更新状态
    form_submission.update(confirmation_email_sent: true, confirmation_email_sent_at: Time.current)
  end

  private

  def generate_qrcode(qrcode_id)
    qrcode = RQRCode::QRCode.new(qrcode_id)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
  end
end 