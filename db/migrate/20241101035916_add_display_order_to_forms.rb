class AddDisplayOrderToForms < ActiveRecord::Migration[7.0]
  def change
    add_column :forms, :display_order, :jsonb, default: [], null: false
  end
end
