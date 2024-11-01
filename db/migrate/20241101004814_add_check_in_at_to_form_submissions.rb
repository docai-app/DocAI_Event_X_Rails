class AddCheckInAtToFormSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :form_submissions, :check_in_at, :datetime
  end
end
