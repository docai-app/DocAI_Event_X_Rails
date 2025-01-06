class CreateEmailTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :email_templates, id: :uuid do |t|
      t.string :name, null: false
      t.string :subject, null: false
      t.text :html_content, null: false
      t.jsonb :placeholders, default: [], null: false # 存儲可用的變量
      t.boolean :is_active, default: true
      t.references :form, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
