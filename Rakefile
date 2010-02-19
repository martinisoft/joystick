begin
  require 'jeweler'
  $LOAD_PATH.unshift 'lib'
  require 'joystick/version'
  Jeweler::Tasks.new do |gem|
    gem.name = "joystick"
    gem.summary = "Game Server Query/Admin Library"
    gem.description = "Ruby library to query numerous game servers and even control them via commands"
    gem.email = "akalin@martinisoftware.com"
    gem.homepage = "http://github.com/martinisoft/joystick"
    gem.authors = ["Aaron Kalin"]
    gem.version = Joystick::Version
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "cucumber", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "joystick #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Push a new version to Gemcutter"
task :publish => [ :test, :gemspec, :build ] do
  system "git tag v#{Joystick::Version}"
  system "git push origin v#{Joystick::Version}"
  system "git push origin master"
  system "gem push pkg/mustache-#{Joystick::Version}.gem"
  system "git clean -fd"
end
