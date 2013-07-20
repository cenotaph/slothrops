ThinkingSphinx::Index.define :review, :with => :active_record do
  indexes body
  indextes review_title
  indexes book(:full_title), :as => :book_title, :sortable => true
  has book_id, created_at, updated_at
end