class AddEmailEnabledToForms < ActiveRecord::Migration[7.0]
  def change
    add_column :forms, :email_enabled, :boolean, default: false
  end
end
