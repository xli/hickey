Gem::Specification.new do |s|
  
  #### Basic information.

  s.name = 'hickey'
  s.version = '0.0.1'
  s.summary = "Hickey is a DSL for preparing Rails test database."

  #### Which files are to be included in this gem?  Everything!  (Except SVN directories.)

  s.files = FileList[
    'install.rb',
    '[A-Z]*',
    'lib/**/*.rb', 
    'test/**/*.rb',
    'doc/**/*'
  ]

  #### Load-time details: library and application (you will need one or both).

  s.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  s.has_rdoc = false

  #### Author and project details.
  s.author = "Li Xiao"
  s.email = "swing1979@gmail.com"
  s.homepage = "https://github.com/xli/hickey/tree"
end
