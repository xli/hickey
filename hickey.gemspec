Gem::Specification.new do |s|
  
  #### Basic information.

  s.name = 'hickey'
  s.version = '0.0.1'
  s.summary = "Hickey provides a simple way of preparing test data inside test for Rails project."

  s.add_dependency('activerecord', '>= 2.1.0')
  #### Which files are to be included in this gem?  Everything!  (Except SVN directories.)

  s.files = Dir.glob("lib/**/*.rb") + Dir.glob("test/**/*.rb") + ["CHANGES", "hickey.gemspec", "LICENSE.TXT", "Rakefile", "README", "TODO"]

  #### Load-time details: library and application (you will need one or both).

  s.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  s.has_rdoc = false

  #### Author and project details.
  s.author = "Li Xiao"
  s.email = "iam@li-xiao.com"
  s.homepage = "https://github.com/xli/hickey/tree"
end
