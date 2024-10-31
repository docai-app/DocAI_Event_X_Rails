class AddConfirmationEmailToFormSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :form_submissions, :confirmation_email_sent, :boolean
    add_column :form_submissions, :confirmation_email_sent_at, :datetime
  end
end
