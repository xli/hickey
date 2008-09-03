require 'test/unit'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'hickey'
TEST_ROOT       = File.expand_path(File.dirname(__FILE__))
ASSETS_ROOT     = TEST_ROOT + "/empty"
FIXTURES_ROOT   = TEST_ROOT + "/empty"
MIGRATIONS_ROOT = TEST_ROOT + "/empty"
SCHEMA_ROOT     = TEST_ROOT + "/empty"
require 'active_record/fixtures'
require 'active_record/test_case'
require 'database_config'
require 'growling_test'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
end
