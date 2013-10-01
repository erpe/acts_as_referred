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

ActiveRecord::Schema.define(version: 20131001152526) do

  create_table "bookings", force: true do |t|
    t.string   "thing"
    t.string   "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referees", force: true do |t|
    t.integer "referable_id"
    t.string  "referable_type"
    t.boolean "is_campaign"
    t.string  "origin"
    t.string  "origin_host"
    t.string  "request"
    t.string  "request_query"
    t.string  "campaign"
    t.string  "keywords"
    t.integer "visits"
  end

  add_index "referees", ["is_campaign"], name: "index_referees_on_is_campaign"
  add_index "referees", ["referable_id"], name: "index_referees_on_referable_id"
  add_index "referees", ["referable_type"], name: "index_referees_on_referable_type"

end
