require 'logger'

RAILS_DEFAULT_LOGGER = Logger.new(File.expand_path(File.dirname(__FILE__)) + '/debug.log')
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER

ActiveRecord::Base.configurations = {
  'test' => {
    :database => ":memory:",
    :adapter => 'sqlite3',
    :timeout => 500
  }
}

ActiveRecord::Base.establish_connection 'test'

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load File.join(File.dirname(__FILE__), 'schema.rb')
end

