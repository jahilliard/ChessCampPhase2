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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140227001956) do

  create_table "camp_instructors", force: true do |t|
    t.integer  "camp_id"
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "camps", force: true do |t|
    t.integer  "curriculum_id"
    t.integer  "cost"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "time_slot"
    t.integer  "max_students"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculums", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "min_rating"
    t.integer  "max_rating"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instructors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "email"
    t.string   "phone"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
