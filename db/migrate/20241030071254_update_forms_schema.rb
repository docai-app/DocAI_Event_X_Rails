class UpdateFormsSchema < ActiveRecord::Migration[7.0]
  def change
    remove_column :forms, :structure, :jsonb
    add_column :forms, :json_schema, :jsonb, default: {}
    add_column :forms, :ui_schema, :jsonb, default: {}
    add_column :forms, :form_data, :jsonb, default: {}
  end
end
