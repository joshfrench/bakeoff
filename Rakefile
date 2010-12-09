desc "Run specs"
task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |spec|
    spec.rspec_opts = ["--color", "--format progress"]
  end
end
