require 'rspec/core/rake_task'

task :default => :test

specs_to_exclude = %w[]

# create separate tasks to isolate each test.
test_tasks = FileList['spec/**/*_spec.rb'].exclude(*specs_to_exclude).map do |path|
  task_name = path.split('/').map{|str| str.gsub(/(\.rb|_spec)/, '')}.join(':')
  desc 'Run an unit spec'
  RSpec::Core::RakeTask.new task_name do |t|
    t.pattern = path
    t.verbose = false
  end.name
end

desc 'Run all unit specs'
task test: test_tasks