# frozen_string_literal: true

class FormSubmissionMailer < ApplicationMailer
  require 'rqrcode'
  require 'mini_magick'

  # def confirmation_email(form_submission_id)
  #   form_submission = FormSubmission.find(form_submission_id)

  #   puts "Sending confirmation email to #{form_submission.submission_data['email']}!!!"

  #   # 强制重新发送邮件，无需检查 confirmation_email_sent
  #   @submission_data = form_submission.submission_data
  #   qrcode_png = generate_qrcode_png(form_submission.qrcode_id)

  #   attachments['qrcode.png'] = qrcode_png

  #   puts "@submission_data: #{@submission_data}"
  #   puts "form_submission: #{form_submission}"

  #   # mail(
  #   #   to: @submission_data['email'],
  #   #   subject: '香港大學活動參與確認 HKU Event Participation Confirmation',
  #   #   from: 'hku-iday-mo-reg@mjsseya.org', &:html
  #   # )

  #   mail(
  #     to: @submission_data['email'],
  #     subject: '活動參與確認 Event Participation Confirmation',
  #     from: 'info@mjsseya.org', &:html
  #   )

  #   # 邮件发送后更新状态
  #   form_submission.update(confirmation_email_sent: true, confirmation_email_sent_at: Time.current)
  # end

  def confirmation_email(form_submission_id)
    retries ||= 0
    @form_submission = FormSubmission.find(form_submission_id)

    # 檢查表單是否啟用郵件功能
    raise StandardError, '此表單未啟用郵件功能' unless @form_submission.form.email_enabled?

    @template = @form_submission.form.email_template
    raise StandardError, '沒有找到郵件模板' unless @template

    @submission_data = @form_submission.submission_data
    qrcode_png = generate_qrcode_png(@form_submission.qrcode_id)
    attachments['qrcode.png'] = qrcode_png

    template = Liquid::Template.parse(@template.html_content)
    @email_content = template.render(@submission_data)

    mail(
      to: @submission_data['email'],
      subject: @template.subject,
      from: 'info@mjsseya.org'
    )

    @form_submission.update(confirmation_email_sent: true, confirmation_email_sent_at: Time.current)
  rescue StandardError => e
    if (retries += 1) <= 3
      Rails.logger.warn("重試發送郵件 #{retries}/3: #{e.message}")
      sleep(2 ** retries)
      retry
    else
      Rails.logger.error("郵件發送失敗: #{e.message}")
      raise
    end
  end

  def validate_email_data
    return false unless form&.email_enabled?
    return false unless form.email_template
    return false if submission_data['email'].blank?
    
    template.placeholders.all? { |p| submission_data[p].present? }
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
    image.format('png')
    image.to_blob
  end
end
