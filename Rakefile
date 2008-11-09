# Rakefile for Hickey        -*- ruby -*-

# Copyright 2007 by Li Xiao (iam@li-xiao.com)
# All rights reserved.

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'hickey'

require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
  nil
end

# The default task is run if rake is given no explicit arguments.

desc "Default Task"
task :default => :test_all

# Common Abbreviations ...

task :test_all => [:test_units]
task :test => :test_units

Rake::TestTask.new(:test_units) do |t|
  t.test_files = FileList['test/*test.rb']
  t.warning = false
  t.verbose = false
end

# Create a task to build the RDOC documentation tree.

rd = Rake::RDocTask.new("rdoc") { |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.template = 'html'
  rdoc.title    = "Hickey"
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README.rdoc' <<
    '--title' <<  'Hickey' 
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE.txt', 'TODO', 'CHANGES')
  rdoc.rdoc_files.include('lib/**/*.rb', 'doc/**/*.rdoc')
}

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  gem_content = <<-GEM
Gem::Specification.new do |spec|
  spec.name = 'hickey'
  spec.version = "0.0.2"
  spec.summary = "Hickey provides a simple way of preparing test data inside test for Rails project."

  #### Dependencies and requirements.
  spec.files = #{(Dir.glob("lib/**/*.rb") + ["CHANGES", "hickey.gemspec", "lib", "LICENSE.TXT", "Rakefile", "README.rdoc", "TODO"]).inspect}

  spec.test_files = #{Dir.glob("test/**/*.rb").inspect}

  #### Load-time details: library and application (you will need one or both).

  spec.require_path = 'lib'                         # Use these for libraries.

  #### Documentation and testing.

  spec.has_rdoc = true
  spec.extra_rdoc_files = #{rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a.inspect}
  spec.rdoc_options = #{rd.options.inspect}

  #### Author and project details.

  spec.author = "Li Xiao"
  spec.email = "iam@li-xiao.com"
  spec.homepage = "http://github.com/xli/hickey/tree/master"
  spec.rubyforge_project = "hickey"
end
GEM
  File.open(File.dirname(__FILE__) + '/hickey.gemspec', 'w') do |f|
    f.write(gem_content)
  end

  #build gem package same steps with github
  File.open(File.dirname(__FILE__) + '/hickey.gemspec') do |f|
    data = f.read
    spec = nil
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
    package_task = Rake::GemPackageTask.new(spec) do |pkg|
      #pkg.need_zip = true
      #pkg.need_tar = true
    end
  end
end

# Misc tasks =========================================================

def count_lines(filename)
  lines = 0
  codelines = 0
  open(filename) { |f|
    f.each do |line|
      lines += 1
      next if line =~ /^\s*$/
      next if line =~ /^\s*#/
      codelines += 1
    end
  }
  [lines, codelines]
end

def show_line(msg, lines, loc)
  printf "%6s %6s   %s\n", lines.to_s, loc.to_s, msg
end

desc "Count lines in the main MM file"
task :lines do
  total_lines = 0
  total_code = 0
  show_line("File Name", "LINES", "LOC")
  FileList['lib/**/*.rb', 'lib/**/*.rake'].each do |fn|
    lines, codelines = count_lines(fn)
    show_line(fn, lines, codelines)
    total_lines += lines
    total_code  += codelines
  end
  show_line("TOTAL", total_lines, total_code)
end
