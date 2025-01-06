# frozen_string_literal: true

class FormSubmissionMailerPreview < ActionMailer::Preview
  # def confirmation_email
  #   # 创建一个示例的 FormSubmission
  #   form_submission = FormSubmission.first || FormSubmission.create(
  #     form_id: SecureRandom.uuid,
  #     submission_data: {
  #       'name' => '張三',
  #       'email' => 'example@example.com',
  #       'phone' => '1234567890'
  #     },
  #     qrcode_id: SecureRandom.uuid
  #   )

  #   # 调用邮件方法
  #   FormSubmissionMailer.confirmation_email(form_submission.id)
  # end
  def confirmation_email(form_submission_id)
    @form_submission = FormSubmission.find(form_submission_id)
    @template = @form_submission.form.email_template
    @submission_data = @form_submission.submission_data

    # 使用 liquid 模板引擎處理內容
    template = Liquid::Template.parse(@template.html_content)
    @email_content = template.render(@submission_data)

    attachments['qrcode.png'] = generate_qrcode_png(@form_submission.qrcode_id)

    mail(
      to: @submission_data['email'],
      subject: @template.subject,
      from: 'info@mjsseya.org'
    )
  end
end
