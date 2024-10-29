# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_241_029_103_256) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'form_submissions', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'form_id', null: false
    t.jsonb 'submission_data', default: {}, null: false
    t.uuid 'qrcode_id', default: -> { 'gen_random_uuid()' }, null: false
    t.boolean 'checked_in', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['form_id'], name: 'index_form_submissions_on_form_id'
    t.index ['qrcode_id'], name: 'index_form_submissions_on_qrcode_id', unique: true
    t.index ['submission_data'], name: 'index_form_submissions_on_submission_data', using: :gin
  end

  create_table 'forms', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name', null: false
    t.string 'description'
    t.jsonb 'structure', default: {}, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['structure'], name: 'index_forms_on_structure', using: :gin
  end

  create_table 'prompts', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'name'
    t.string 'description'
    t.text 'template'
    t.jsonb 'openai_meta', default: {}, null: false
    t.jsonb 'params', default: {}, null: false
    t.jsonb 'meta', default: {}, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_prompts_on_user_id'
  end

  create_table 'roles', force: :cascade do |t|
    t.string 'name'
    t.string 'resource_type'
    t.bigint 'resource_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[name resource_type resource_id], name: 'index_roles_on_name_and_resource_type_and_resource_id'
    t.index %w[resource_type resource_id], name: 'index_roles_on_resource'
  end

  create_table 'taggings', force: :cascade do |t|
    t.bigint 'tag_id'
    t.string 'taggable_type'
    t.bigint 'taggable_id'
    t.string 'tagger_type'
    t.bigint 'tagger_id'
    t.string 'context', limit: 128
    t.datetime 'created_at', precision: nil
    t.string 'tenant', limit: 128
    t.index ['context'], name: 'index_taggings_on_context'
    t.index %w[tag_id taggable_id taggable_type context tagger_id tagger_type], name: 'taggings_idx',
                                                                                unique: true
    t.index ['tag_id'], name: 'index_taggings_on_tag_id'
    t.index %w[taggable_id taggable_type context], name: 'taggings_taggable_context_idx'
    t.index %w[taggable_id taggable_type tagger_id context], name: 'taggings_idy'
    t.index ['taggable_id'], name: 'index_taggings_on_taggable_id'
    t.index %w[taggable_type taggable_id], name: 'index_taggings_on_taggable_type_and_taggable_id'
    t.index ['taggable_type'], name: 'index_taggings_on_taggable_type'
    t.index %w[tagger_id tagger_type], name: 'index_taggings_on_tagger_id_and_tagger_type'
    t.index ['tagger_id'], name: 'index_taggings_on_tagger_id'
    t.index %w[tagger_type tagger_id], name: 'index_taggings_on_tagger_type_and_tagger_id'
    t.index ['tenant'], name: 'index_taggings_on_tenant'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'taggings_count', default: 0
    t.index ['name'], name: 'index_tags_on_name', unique: true
  end

  create_table 'user_prompts', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'prompt_id', null: false
    t.jsonb 'params'
    t.string 'cache_key'
    t.text 'raw_response'
    t.jsonb 'response'
    t.integer 'status', default: 0, null: false
    t.datetime 'start_at'
    t.datetime 'end_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['cache_key'], name: 'index_user_prompts_on_cache_key'
    t.index ['end_at'], name: 'index_user_prompts_on_end_at'
    t.index ['prompt_id'], name: 'index_user_prompts_on_prompt_id'
    t.index ['start_at'], name: 'index_user_prompts_on_start_at'
    t.index ['status'], name: 'index_user_prompts_on_status'
    t.index ['user_id'], name: 'index_user_prompts_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'users_roles', id: false, force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'role_id'
    t.index ['role_id'], name: 'index_users_roles_on_role_id'
    t.index %w[user_id role_id], name: 'index_users_roles_on_user_id_and_role_id'
    t.index ['user_id'], name: 'index_users_roles_on_user_id'
  end

  add_foreign_key 'form_submissions', 'forms'
  add_foreign_key 'prompts', 'users'
  add_foreign_key 'taggings', 'tags'
  add_foreign_key 'user_prompts', 'prompts'
  add_foreign_key 'user_prompts', 'users'
end
