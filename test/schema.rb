ActiveRecord::Schema.define do
  create_table :simples do |t|
  end

  create_table "projects", :force => true do |t|
    t.column "identifier",                  :string
    t.column "description",                 :text
    t.column "created_at",                  :datetime
    t.column "updated_at",                  :datetime
    t.column "created_on",                  :datetime
    t.column "updated_on",                  :datetime
    t.column "hidden",                      :boolean
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string
    t.column "admin",                     :boolean
  end

  create_table "topics", :force => true do |t|
    t.column "user_id",                   :integer
    t.column "writer_id",                 :integer
    t.column "writer_type",               :string
    t.column "title",                     :string
    t.column "disscution_id",    :integer
  end

  create_table "projects_members", :force => true do |t|
    t.column "user_id",    :integer
    t.column "project_id", :integer
    t.column "admin",      :boolean
  end

  create_table "countries_users", :id => false, :force => true do |t|
    t.column "user_id",      :integer, :null => false
    t.column "country_id",   :integer, :null => false
  end

  create_table "countries", :force => true do |t|
    t.column "id",          :integer
    t.column "name",        :string
  end

  create_table "addresses", :force => true do |t|
    t.column "id",          :integer
    t.column "user_id",     :integer
    t.column "country_id",  :integer
    t.column "location",    :string
  end
  
  create_table "disscutions", :force => true do |t|
    t.column "id",          :integer
  end

  create_table "disscution_belongs_to_topics", :force => true do |t|
    t.column "id",          :integer
    t.column 'topic_id',    :integer
  end

  create_table "property_definitions", :force => true do |t|
    t.column "type",        :string,    :null => false
    t.column "project_id",  :integer
    t.column "name",        :string,  :default => "",    :null => false
  end

  create_table "enum_values", :force => true do |t|
    t.column "value",                  :string,  :default => "", :null => false
    t.column "property_definition_id", :integer
    t.column "position",               :integer
  end
end
