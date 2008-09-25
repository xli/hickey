Gem::Specification.new do |s|
  
  #### Basic information.

  s.name = 'hickey'
  s.version = '0.0.1'
  s.summary = "Hickey provides a simple way of preparing test data inside test for Rails project."

  s.add_dependency('activerecord', '>= 2.1.0')
  #### Which files are to be included in this gem?  Everything!  (Except SVN directories.)
  # p Dir.glob("lib/**/*.rb") + Dir.glob("test/**/*.rb")
  s.files = ["lib/hickey/acceptor.rb", "lib/hickey/domain_detector/actions.rb", "lib/hickey/domain_detector/associations.rb", "lib/hickey/domain_detector/base.rb", "lib/hickey/domain_detector/configurable.rb", "lib/hickey/domain_detector/scopes.rb", "lib/hickey/domain_detector.rb", "lib/hickey.rb", "test/belongs_to_association_test.rb", "test/database_config.rb", "test/enable_callbacks_test.rb", "test/find_or_create_actions_test.rb", "test/has_and_belongs_to_many_association_test.rb", "test/has_many_association_test.rb", "test/has_one_association_test.rb", "test/model_association_test.rb", "test/models/address.rb", "test/models/author.rb", "test/models/country.rb", "test/models/project.rb", "test/models/projects_member.rb", "test/models/property_definition.rb", "test/models/simple.rb", "test/models/tag.rb", "test/models/topic.rb", "test/models/user.rb", "test/models/writer.rb", "test/schema.rb", "test/single_model_test.rb", "test/test_helper.rb", "test/with_scope_test.rb"] + ["CHANGES", "hickey.gemspec", "LICENSE.TXT", "Rakefile", "README", "TODO"]

  #### Load-time details: library and application (you will need one or both).

  s.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  s.has_rdoc = false

  #### Author and project details.
  s.author = "Li Xiao"
  s.email = "iam@li-xiao.com"
  s.homepage = "https://github.com/xli/hickey/tree"
end
