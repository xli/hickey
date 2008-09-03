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
    def create_table(name, &block)
      return if connection.table_exists?(name)
      if block_given?
        connection.create_table(name, &block)
      else
        connection.create_table(name) {|t|}
      end
    end
    
    def connection
      ActiveRecord::Base.connection
    end
  end
end

Hickey::TestHelper.instance.create_table :simples

