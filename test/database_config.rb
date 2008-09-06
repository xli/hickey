puts "Using native PostgreSQL"
require 'logger'

RAILS_DEFAULT_LOGGER = Logger.new(File.expand_path(File.dirname(__FILE__)) + '/debug.log')
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER

ActiveRecord::Base.configurations = {
  'test' => {
    :adapter  => 'postgresql',
    :database => 'hickey_test',
    :min_messages => 'ERROR'
  }
}

ActiveRecord::Base.establish_connection 'test'

require 'singleton'
module Hickey
  class TestHelper
    include Singleton
    def create_table(name, options={}, &block)
      return if connection.table_exists?(name)
      if block_given?
        connection.create_table(name, options, &block)
      else
        connection.create_table(name, options) {|t|}
      end
    end
    
    def connection
      ActiveRecord::Base.connection
    end
  end
end

Hickey::TestHelper.instance.create_table :simples

Hickey::TestHelper.instance.create_table "projects", :force => true do |t|
  t.column "identifier",                  :string,   :default => "",         :null => false
  t.column "description",                 :text
  t.column "created_at",                  :datetime
  t.column "updated_at",                  :datetime
  t.column "created_on",                  :datetime
  t.column "updated_on",                  :datetime
  t.column "hidden",                      :boolean,  :default => false
end

Hickey::TestHelper.instance.create_table "users", :force => true do |t|
  t.column "login",                     :string,                   :default => "",   :null => false
  t.column "admin",                     :boolean
end

Hickey::TestHelper.instance.create_table "projects_members", :force => true do |t|
  t.column "user_id",    :integer,                    :null => false
  t.column "project_id", :integer,                    :null => false
  t.column "admin",      :boolean, :default => false, :null => false
end
