ThinkingSphinx::Index.define :inventory, :with => :active_record do
  indexes notes
  indexes description
  indexes full_title, :as => :title, :sortable => true
  has edition_id, created_at, updated_at
  set_property :field_weights => {
    :title => 10,
    :description => 5,
    :notes => 4
  }
end