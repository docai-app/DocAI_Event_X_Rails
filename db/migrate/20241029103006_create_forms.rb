class CreateForms < ActiveRecord::Migration[7.0]
  def change
    create_table :forms, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.jsonb :structure, null: false, default: {}

      t.timestamps
    end

    add_index :forms, :structure, using: :gin
  end
end
