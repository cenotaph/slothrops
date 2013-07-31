# ThinkingSphinx::Index.define :edition, :with => :active_record do
#   indexes product_description
#   indexes book(:full_title), :as => :title, :sortable => true
#   has book_id, created_at, updated_at
# end