Gem::Specification.new do |spec|
  spec.name = 'hickey'
  spec.version = "0.0.2"
  spec.summary = "Hickey provides a simple way of preparing test data inside test for Rails project."

  #### Dependencies and requirements.
  spec.files = ["lib/hickey/acceptor.rb", "lib/hickey/domain_detector/actions.rb", "lib/hickey/domain_detector/associations.rb", "lib/hickey/domain_detector/base.rb", "lib/hickey/domain_detector/configurable.rb", "lib/hickey/domain_detector/scopes.rb", "lib/hickey/domain_detector.rb", "lib/hickey.rb", "CHANGES", "hickey.gemspec", "lib", "LICENSE.TXT", "Rakefile", "README.rdoc", "TODO"]

  spec.test_files = ["test/belongs_to_association_test.rb", "test/database_config.rb", "test/enable_callbacks_test.rb", "test/find_or_create_actions_test.rb", "test/has_and_belongs_to_many_association_test.rb", "test/has_many_association_test.rb", "test/has_one_association_test.rb", "test/model_association_test.rb", "test/models/address.rb", "test/models/author.rb", "test/models/country.rb", "test/models/project.rb", "test/models/projects_member.rb", "test/models/property_definition.rb", "test/models/simple.rb", "test/models/tag.rb", "test/models/topic.rb", "test/models/user.rb", "test/models/writer.rb", "test/schema.rb", "test/single_model_test.rb", "test/test_helper.rb", "test/with_scope_test.rb"]

  #### Load-time details: library and application (you will need one or both).

  spec.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  spec.has_rdoc = true
  spec.extra_rdoc_files = ["README.rdoc", "LICENSE.txt", "TODO", "CHANGES"]
  spec.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc", "--title", "Hickey"]

  #### Author and project details.

  spec.author = "Li Xiao"
  spec.email = "iam@li-xiao.com"
  spec.homepage = "http://github.com/xli/hickey/tree/master"
  spec.rubyforge_project = "hickey"
end
