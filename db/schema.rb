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

ActiveRecord::Schema.define(:version => 20121016180120) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "diseases", :force => true do |t|
    t.integer  "omim_id"
    t.string   "disease_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "diseases", ["disease_name"], :name => "index_diseases_on_disease_name"
  add_index "diseases", ["omim_id"], :name => "index_diseases_on_omim_id", :unique => true

  create_table "genes", :force => true do |t|
    t.integer  "hgnc_id"
    t.string   "symbol"
    t.string   "name"
    t.string   "synonym"
    t.string   "name_synonym",        :limit => 5000
    t.string   "chromosome_location"
    t.string   "accession_numbers"
    t.string   "ensembl_gene_id"
    t.string   "mgi_id"
    t.string   "refseq_id"
    t.string   "uniprot_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "genes", ["hgnc_id"], :name => "index_genes_on_hgnc_id", :unique => true
  add_index "genes", ["symbol"], :name => "index_genes_on_symbol", :unique => true

end
