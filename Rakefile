require 'rake'
require 'rake/testtask'
require 'rcov/rcovtask'
 
desc 'Default: run unit tests.'
task :default => :test
 
desc 'Test it.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc "Generate code coverage report for it."
Rcov::RcovTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.rcov_opts << '-x Shoulda'
  t.rcov_opts << '-x rcov'
  t.rcov_opts << '--charset UTF-8'
  t.verbose = true
end
