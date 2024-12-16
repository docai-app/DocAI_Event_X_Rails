class AddMetaToForms < ActiveRecord::Migration[7.0]
  def change
    add_column :forms, :meta, :jsonb, default: {}, null: false
    add_index :forms, :meta, using: :gin
  end
end
