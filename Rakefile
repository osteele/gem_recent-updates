require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts = ["-T -x '/Library/Ruby/*'"]
    t.verbose = true
  end
rescue LoadError
  $stderr.puts "Rcov not available. Install it for rcov-related tasks with:"
  $stderr.puts "  sudo gem install rcov"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'gem_recent-updates'
    s.description = "Adds a gem command that displays the new portions of the history files of recently updated gems."
    s.summary = "A gem command plugin that displays the tops of the history files of recently updated gems."
    s.email = "gabriel.horner@gmail.com"
    s.homepage = "http://github.com/osteele/gem_recent-updates"
    s.authors = ["Oliver Steele"]
    s.has_rdoc = true
    s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
    s.files = FileList["[A-Z]*", "{bin,lib,test}/**/*"]
  end

rescue LoadError
  $stderr.puts "Jeweler not available. Install it for jeweler-related tasks with:"
  $stderr.puts "  sudo gem install jeweler"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'test'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
