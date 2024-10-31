class FormSubmissionMailer < ApplicationMailer
  require 'rqrcode'
  require 'mini_magick'

  def confirmation_email(form_submission_id)
    form_submission = FormSubmission.find(form_submission_id)

    # 强制重新发送邮件，无需检查 confirmation_email_sent
    @submission_data = form_submission.submission_data
    qrcode_png = generate_qrcode_png(form_submission.qrcode_id)

    attachments['qrcode.png'] = qrcode_png

    mail(
      to: @submission_data['email'],
      subject: "Form Submission Confirmation",
      from: 'hku-iday-mo-reg@mjsseya.org'
    ) do |format|
      format.html
    end

    # 邮件发送后更新状态
    form_submission.update(confirmation_email_sent: true, confirmation_email_sent_at: Time.current)
  end

  private

  def generate_qrcode_png(qrcode_id)
    qrcode = RQRCode::QRCode.new(qrcode_id)
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 10,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 240
    )
    # 使用 MiniMagick 将 PNG 转换为二进制数据
    image = MiniMagick::Image.read(png.to_s)
    image.format("png")
    image.to_blob
  end
end 