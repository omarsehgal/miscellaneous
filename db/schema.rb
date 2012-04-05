# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120209181127) do

  create_table "addr_books", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "idsid"
    t.string   "category"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.text     "content",                 :limit => 255
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "att_path"
    t.integer  "project_id"
    t.integer  "category_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.integer  "team_id"
    t.string   "email_list"
    t.string   "from_email"
    t.string   "status"
    t.datetime "sent_at"
    t.text     "cc_list"
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tup",                     :default => 0
    t.integer  "tdown",                   :default => 0
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "user"
  end

  create_table "approvers", :force => true do |t|
    t.string   "name"
    t.string   "idsid"
    t.string   "team"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner"
    t.string   "email"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_home",               :default => false
    t.string   "category"
    t.boolean  "DbTeam"
  end

  create_table "keywords", :force => true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", :force => true do |t|
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likeable_id"
    t.string   "likeable_type"
  end

  create_table "links", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "link"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_home",   :default => false
    t.boolean  "DbTeam"
    t.string   "category"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "coverage_area"
    t.string   "ooo_info"
    t.string   "fav_snack"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_lead"
    t.string   "site"
    t.string   "projects"
    t.string   "idsid"
    t.integer  "team_id"
    t.integer  "dbadmin"
  end

  create_table "monitor_actions", :force => true do |t|
    t.string   "name"
    t.text     "script"
    t.text     "description"
    t.string   "created_by"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monitor_item_id"
  end

  create_table "monitor_items", :force => true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.string   "category"
    t.text     "description"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_users", :force => true do |t|
    t.string   "name"
    t.string   "user_type"
    t.string   "sponsor"
    t.string   "team"
    t.text     "justification"
    t.integer  "duration"
    t.integer  "diskspace"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project"
    t.string   "status"
    t.boolean  "sponsor_approved"
    t.string   "disk_path"
  end

  create_table "questions", :force => true do |t|
    t.integer  "category_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin"
  end

end
