class FormSubmissionMailerPreview < ActionMailer::Preview
  def confirmation_email
    # 创建一个示例的 FormSubmission
    form_submission = FormSubmission.first || FormSubmission.create(
      form_id: SecureRandom.uuid,
      submission_data: {
        "name" => "張三",
        "email" => "example@example.com",
        "phone" => "1234567890"
      },
      qrcode_id: SecureRandom.uuid
    )

    # 调用邮件方法
    FormSubmissionMailer.confirmation_email(form_submission.id)
  end
end 