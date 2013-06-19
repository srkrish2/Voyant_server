# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130619215552) do

  create_table "audience_configurations", :force => true do |t|
    t.integer  "design_id",         :null => false
    t.string   "gender",            :null => false
    t.string   "age",               :null => false
    t.string   "country",           :null => false
    t.string   "design_experience", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "boxareas", :force => true do |t|
    t.integer  "turker_id",      :null => false
    t.integer  "feedback_id",    :null => false
    t.string   "feedback_type",  :null => false
    t.float    "top_left_x",     :null => false
    t.float    "top_left_y",     :null => false
    t.float    "bottom_right_x", :null => false
    t.float    "bottom_right_y", :null => false
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "designs", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "element_configurations", :force => true do |t|
    t.integer  "design_id",                      :null => false
    t.string   "name",                           :null => false
    t.boolean  "is_required",  :default => true
    t.integer  "turker_num",   :default => 0
    t.float    "turker_price", :default => 0.0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "element_feedbacks", :force => true do |t|
    t.integer  "design_id",                       :null => false
    t.integer  "configuration_id",                :null => false
    t.string   "name",                            :null => false
    t.integer  "vote",             :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "first_notice_configurations", :force => true do |t|
    t.integer  "design_id",                      :null => false
    t.boolean  "is_required",  :default => true
    t.integer  "turker_num",   :default => 0
    t.float    "turker_price", :default => 0.0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "first_notice_feedbacks", :force => true do |t|
    t.integer  "design_id",           :null => false
    t.integer  "element_feedback_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "goal_configurations", :force => true do |t|
    t.integer  "design_id",                      :null => false
    t.string   "title",                          :null => false
    t.text     "description"
    t.boolean  "is_required",  :default => true
    t.integer  "turker_num",   :default => 0
    t.float    "turker_price", :default => 0.0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "goal_feedbacks", :force => true do |t|
    t.integer  "design_id",                       :null => false
    t.integer  "configuration_id",                :null => false
    t.integer  "rating",           :default => 1
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "guideline_configurations", :force => true do |t|
    t.integer  "design_id",                      :null => false
    t.string   "title",                          :null => false
    t.text     "description"
    t.boolean  "is_required",  :default => true
    t.integer  "turker_num",   :default => 0
    t.float    "turker_price", :default => 0.0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "guideline_templates", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "title",       :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "impression_configurations", :force => true do |t|
    t.integer  "design_id",                       :null => false
    t.boolean  "is_required",   :default => true
    t.integer  "turker_num1",   :default => 0
    t.float    "turker_price1", :default => 0.0
    t.integer  "turker_num2",   :default => 0
    t.float    "turker_price2", :default => 0.0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "impression_feedbacks", :force => true do |t|
    t.integer  "design_id",                 :null => false
    t.string   "name",                      :null => false
    t.integer  "vote",       :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "turkers", :force => true do |t|
    t.integer  "age",                              :null => false
    t.integer  "gender",            :default => 0
    t.string   "country",                          :null => false
    t.integer  "design_experience", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "design_experience",      :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
