Gem::Specification.new do |s|
  
  #### Basic information.

  s.name = 'hickey'
  s.version = '0.0.1'
  s.summary = "Hickey is a DSL for preparing Rails test database."

  s.add_dependency('activerecord', '>= 2.1.0')
  #### Which files are to be included in this gem?  Everything!  (Except SVN directories.)

  s.files = ["lib/hickey.rb", "CHANGES", "hickey.gemspec", "lib", "LICENSE.TXT", "Rakefile", "README", "TODO"]

  #### Load-time details: library and application (you will need one or both).

  s.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  s.has_rdoc = false

  #### Author and project details.
  s.author = "Li Xiao"
  s.email = "iam@li-xiao.com"
  s.homepage = "https://github.com/xli/hickey/tree"
end
