class CreateFormSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :form_submissions, id: :uuid do |t|
      t.references :form, type: :uuid, null: false, foreign_key: true
      t.jsonb :submission_data, null: false, default: {}
      t.uuid :qrcode_id, null: false, default: 'gen_random_uuid()'
      t.boolean :checked_in, default: false

      t.timestamps
    end

    add_index :form_submissions, :qrcode_id, unique: true
    add_index :form_submissions, :submission_data, using: :gin
  end
end
