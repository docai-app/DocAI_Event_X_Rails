# frozen_string_literal: true

namespace :import do
  desc '從CSV導入表單提交數據'
  task form_submissions: :environment do
    require 'csv'

    def split_name(full_name)
      return [full_name[0], full_name[1..]] if full_name.present?

      ['', '']
    end

    form = Form.first # 或者指定特定的form_id

    CSV.foreach(Rails.root.join('HKU_iDAY_學校B2B報名_20241106.csv'), headers: true, encoding: 'utf-8') do |row|
      last_name, first_name = split_name(row['姓名'])

      submission_data = {
        'interests' => [],
        'eventSource' => [],
        'role' => row['職務'] || 'Student 學生',
        'email' => row['電郵地址'],
        'country' => '',
        'lastName' => last_name,
        'firstName' => first_name,
        'curriculum' => 'HKDSE 香港中學文憑試',
        'salutation' => 'Mr. 先生',
        'schoolName' => row['學校'],
        'mobileNumber' => row['手機號碼'],
        'otherInterests' => '',
        'otherEventSource' => '',
        'yearOfAdmissions' => row['入讀大學年份']
      }

      form_submission = FormSubmission.new(
        form:,
        submission_data:,
        confirmation_email_sent: false # 明確設置為 false
      )

      if form_submission.save
        puts "成功創建提交記錄: #{submission_data['lastName']} #{submission_data['firstName']}"
      else
        puts "創建提交記錄失敗: #{submission_data['lastName']} #{submission_data['firstName']}, 錯誤: #{form_submission.errors.full_messages.join(', ')}"
      end

      # 強制觸發郵件發送
      unless form_submission.confirmation_email_sent
        begin
          FormSubmissionMailer.confirmation_email(form_submission.id).deliver_later
          puts "成功發送確認郵件到: #{submission_data['email']}"
        rescue StandardError => e
          puts "發送確認郵件失敗: #{e.message}"
        end
      end
    end
  end
end
