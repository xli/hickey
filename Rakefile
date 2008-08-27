# Rakefile for Hickey        -*- ruby -*-

# Copyright 2007 by Li Xiao (swing1979@gmail.com)
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
CLEAN.include('**/*.o', '*.dot')
CLOBBER.include('TAGS')
CLOBBER.include('coverage', 'rcov_aggregate')

def announce(msg='')
  STDERR.puts msg
end

SRC_RB = FileList['lib/**/*.rb', 'lib/**/*.rake']

# The default task is run if rake is given no explicit arguments.

desc "Default Task"
task :default => :test_all

# Test Tasks ---------------------------------------------------------
task :dbg do |t|
  puts "Arguments are: #{t.args.join(', ')}"
end

# Common Abbreviations ...

task :test_all => [:test_units]
task :test => :test_units

Rake::TestTask.new(:test_units) do |t|
  t.test_files = FileList['test/*test.rb']
  t.warning = false
  t.verbose = false
end

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.libs << "test"
    t.rcov_opts = [
      '-xRakefile', '-xrakefile', '-xpublish.rf', '--text-report',
    ]
    t.test_files = FileList[
      'test/*test.rb'
    ]
    t.output_dir = 'coverage'
    t.verbose = true
  end
rescue LoadError
  # No rcov available
end

# Install MM using the standard install.rb script.

desc "Install the application"
task :install do
  ruby "install.rb"
end

# Create a task to build the RDOC documentation tree.

rd = Rake::RDocTask.new("rdoc") { |rdoc|
  rdoc.rdoc_dir = 'html'
#  rdoc.template = 'kilmer'
#  rdoc.template = 'css2'
  rdoc.template = 'doc/jamis.rb'
  rdoc.title    = "Hickey"
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README' <<
    '--title' <<  'Hickey' 
  rdoc.rdoc_files.include('README', 'LICENSE.txt', 'TODO', 'CHANGES')
  rdoc.rdoc_files.include('lib/**/*.rb', 'doc/**/*.rdoc')
}

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
  SRC_RB.each do |fn|
    lines, codelines = count_lines(fn)
    show_line(fn, lines, codelines)
    total_lines += lines
    total_code  += codelines
  end
  show_line("TOTAL", total_lines, total_code)
end

# Define an optional publish target in an external file.  If the
# publish.rf file is not found, the publish targets won't be defined.

load "publish.rf" if File.exist? "publish.rf"

# Support Tasks ------------------------------------------------------

RUBY_FILES = FileList['**/*.rb'].exclude('pkg')

desc "Look for TODO and FIXME tags in the code"
task :todo do
  RUBY_FILES.egrep(/#.*(FIXME|TODO|TBD)/)
end

desc "Look for Debugging print lines"
task :dbg do
  RUBY_FILES.egrep(/\bDBG|\bbreakpoint\b/)
end

