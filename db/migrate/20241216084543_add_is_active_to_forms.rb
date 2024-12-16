class AddIsActiveToForms < ActiveRecord::Migration[7.0]
  def change
    add_column :forms, :is_active, :boolean, default: false, null: false
  end
end
