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



ActiveRecord::Schema.define(:version => 20131021094605) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookbuys", :force => true do |t|
    t.integer  "user_id"
    t.date     "day_of_sale"
    t.float    "amount"
    t.string   "source"
    t.text     "notes"
    t.float    "creditamt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
    t.integer  "payments_count",    :default => 0
    t.integer  "inventories_count", :default => 0
  end

  add_index "bookbuys", ["user_id"], :name => "index_bookbuys_on_user_id"

  create_table "books", :force => true do |t|
    t.integer  "category_id"
    t.integer  "creator_id"
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reviews_count",           :default => 0
    t.integer  "consignment_items_count", :default => 0
  end

  add_index "books", ["category_id"], :name => "index_books_on_category_id"
  add_index "books", ["creator_id"], :name => "index_books_on_creator_id"
  add_index "books", ["slug"], :name => "index_books_on_slug", :unique => true

  create_table "carousels", :force => true do |t|
    t.string   "image"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.boolean  "show_first"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "consigners", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "consignment_sales_count"
    t.string   "contact_name"
    t.string   "report_info"
    t.boolean  "legit",                   :default => false, :null => false
    t.boolean  "email_on_every_sale",     :default => true,  :null => false
  end

  create_table "consignment_items", :force => true do |t|
    t.integer  "edition_id"
    t.float    "price"
    t.float    "wholesale"
    t.integer  "stock_count"
    t.date     "acquired"
    t.string   "initialed"
    t.integer  "consigner_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "condition"
    t.integer  "record_id"
    t.string   "item_image"
    t.string   "name"
    t.text     "item_description"
    t.string   "invoice_number"
    t.integer  "item_image_size",         :limit => 8
    t.string   "item_image_content_type"
    t.integer  "item_image_height"
    t.integer  "item_image_width"
  end

  add_index "consignment_items", ["consigner_id"], :name => "index_consignment_items_on_consigner_id"
  add_index "consignment_items", ["edition_id"], :name => "index_consignment_items_on_edition_id"
  add_index "consignment_items", ["slug"], :name => "index_consignment_items_on_slug", :unique => true

  create_table "consignment_sales", :force => true do |t|
    t.integer  "consignment_item_id"
    t.integer  "sale_id"
    t.datetime "payment_collected_at"
  end

  create_table "creators", :force => true do |t|
    t.string   "sortname"
    t.string   "displayname"
    t.string   "first_name"
    t.string   "surname"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "creators", ["slug"], :name => "index_creators_on_slug", :unique => true

  create_table "editions", :force => true do |t|
    t.integer  "book_id"
    t.string   "format"
    t.text     "product_description"
    t.string   "amazoncode"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "barcode"
    t.integer  "image_size",          :limit => 8
    t.string   "image_content_type"
    t.integer  "image_height"
    t.integer  "image_width"
  end

  add_index "editions", ["book_id"], :name => "index_editions_on_book_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "facebook"
    t.integer  "fb_id",              :limit => 8
    t.string   "image"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_content_type"
    t.integer  "image_size",         :limit => 8
  end

  add_index "events", ["fb_id"], :name => "index_events_on_fb_id", :unique => true

  create_table "expenses", :force => true do |t|
    t.date     "expense_date"
    t.string   "description"
    t.float    "amount"
    t.string   "notes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recipient"
  end

  create_table "inventories", :force => true do |t|
    t.integer  "edition_id"
    t.string   "condition"
    t.text     "notes"
    t.integer  "box"
    t.float    "price"
    t.float    "omahind"
    t.string   "source"
    t.string   "image"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                        :default => false, :null => false
    t.date     "acquired"
    t.boolean  "sold",                            :default => false, :null => false
    t.string   "initialed"
    t.integer  "sale_id"
    t.integer  "bookbuy_id"
    t.boolean  "jan2013audit"
    t.integer  "image_size",         :limit => 8
    t.string   "image_content_type"
    t.integer  "image_height"
    t.integer  "image_width"
  end

  add_index "inventories", ["edition_id"], :name => "index_inventories_on_edition_id"
  add_index "inventories", ["slug"], :name => "index_inventories_on_slug", :unique => true

  create_table "musiccategories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "payments", :force => true do |t|
    t.integer  "paymenttype_id"
    t.integer  "sale_id"
    t.string   "note"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voucher_id"
    t.integer  "bookbuy_id"
  end

  add_index "payments", ["paymenttype_id"], :name => "index_payments_on_paymenttype_id"
  add_index "payments", ["sale_id"], :name => "index_payments_on_sale_id"

  create_table "paymenttypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podcastlinks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.float    "sortorder"
    t.integer  "podcast_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podcasts", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.boolean  "published"
    t.string   "image"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "creator_id"
    t.string   "subject"
    t.text     "body"
    t.string   "image"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.boolean  "sticky"
    t.integer  "fb_id",              :limit => 8
    t.string   "fb_link"
    t.integer  "image_size",         :limit => 8
    t.string   "image_content_type"
    t.integer  "image_height"
    t.integer  "image_width"
    t.integer  "event_id"
  end

  add_index "posts", ["book_id"], :name => "index_posts_on_book_id"
  add_index "posts", ["fb_id"], :name => "index_posts_on_fb_id", :unique => true
  add_index "posts", ["slug"], :name => "index_posts_on_slug", :unique => true
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", :force => true do |t|
    t.string   "artist"
    t.string   "title"
    t.string   "label"
    t.string   "format"
    t.string   "image"
    t.string   "slug"
    t.string   "catalog"
    t.integer  "year"
    t.integer  "master_id"
    t.integer  "musiccategory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discogs_id"
    t.integer  "image_size",         :limit => 8
    t.string   "image_content_type"
    t.integer  "image_height"
    t.integer  "image_width"
  end

  add_index "records", ["slug"], :name => "index_records_on_slug", :unique => true

  create_table "reviews", :force => true do |t|
    t.integer  "book_id"
    t.string   "review_title"
    t.integer  "user_id"
    t.string   "reviewer_name"
    t.text     "body"
    t.string   "slug"
    t.boolean  "published"
    t.boolean  "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "abstract"
  end

  add_index "reviews", ["book_id"], :name => "index_reviews_on_book_id"
  add_index "reviews", ["slug"], :name => "index_reviews_on_slug", :unique => true
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sales", :force => true do |t|
    t.integer  "user_id"
    t.float    "discount"
    t.string   "discount_reason"
    t.datetime "sold_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payments_count",  :default => 0
    t.integer  "vouchers_count",  :default => 0
    t.text     "comment"
  end

  add_index "sales", ["user_id"], :name => "index_sales_on_user_id"

  create_table "staticpages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "abstract"
  end

  add_index "staticpages", ["slug"], :name => "index_staticpages_on_slug", :unique => true

  create_table "storeitems", :force => true do |t|
    t.string   "title"
    t.string   "item_type"
    t.integer  "item_id"
    t.date     "acquisition_date"
    t.float    "price"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.text    "tag_description"
    t.boolean "show_out_of_stock"
    t.string  "slug"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "real_name"
    t.string   "location"
    t.string   "website"
    t.text     "about_me"
    t.string   "twitter"
    t.string   "image"
    t.string   "slug"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "vouchers", :force => true do |t|
    t.date     "sold_at"
    t.string   "number"
    t.float    "amount"
    t.integer  "user_id"
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
