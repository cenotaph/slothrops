ThinkingSphinx::Index.define :book, :with => :active_record do
  indexes title, :sortable => true
  indexes creator(:displayname), :as => :author, :sortable => true
 
end