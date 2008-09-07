ActiveRecord::Schema.define do
  create_table :simples do |t|
  end

  create_table "projects", :force => true do |t|
    t.column "identifier",                  :string,   :default => "",         :null => false
    t.column "description",                 :text
    t.column "created_at",                  :datetime
    t.column "updated_at",                  :datetime
    t.column "created_on",                  :datetime
    t.column "updated_on",                  :datetime
    t.column "hidden",                      :boolean,  :default => false
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string, :default => "", :null => false
    t.column "admin",                     :boolean
  end

  create_table "topics", :force => true do |t|
    t.column "user_id",                   :integer, :null => false
    t.column "title",                     :string
  end

  create_table "projects_members", :force => true do |t|
    t.column "user_id",    :integer
    t.column "project_id", :integer
    t.column "admin",      :boolean, :default => false, :null => false
  end

  create_table "countries_users", :id => false, :force => true do |t|
    t.column "user_id",      :integer, :null => false
    t.column "country_id",   :integer, :null => false
  end

  create_table "countries", :force => true do |t|
    t.column "id",          :integer, :null => false
    t.column "name",        :string, :null => false
  end
end
