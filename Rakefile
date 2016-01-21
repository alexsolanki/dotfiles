# RakeFile for Jenkins puppet build jobs. Can perform the following:
#
# - puppet-lint check of *.pp
# - puppet parser validate of *.pp
# - Syntax validation of *.erb
# - Syntax validation of *.yaml
#
# Not fully implimented:
#
# - Generate documentation
# - Run spec tasks
#
# This script is inspired from https://gist.github.com/1868475
#
require 'rake'
require 'erb'
require 'open3'


desc "Default: syntax, erb, lint"
task :default => [:syntax, :erb, :lint]


desc "Display all the possible targets"
task :help do
  sh %{rake -T}
end


desc "Check puppet modules syntax with puppet parser validate. Takes in an optional directory, otherwise it checks all"
task :syntax, [:directory] do |t, args|

  puts "Checking puppet modules syntax with puppet parser validate... "

  args.with_defaults(:directory => "all")
  puppet_files = []
  directory = args[:directory]
  if directory == "all"
    puppet_files = FileList['**/*.pp']
  else
    puppet_path = directory + '/**/*.pp'
    puts "Checking out path #{puppet_path}"
    puppet_files = Dir["#{puppet_path}"]
  end

  system "puppet parser validate " + puppet_files.join(" ") or fail
  puts "Done"
  $stdout.flush
end


desc "Test erb syntax. Takes in an optional directory, otherwise it checks all"
task :erb, [:directory] do |t, args|

  puts "Checking erb templates syntax... "

  error_detected = false
  args.with_defaults(:directory => "all")
  erb_files = []
  directory = args[:directory]
  if directory == "all"
    erb_files = FileList['**/*.erb']
  else
    erb_path = directory + '/**/*.erb'
    puts "Checking out path #{erb_path}"
    erb_files = Dir["#{erb_path}"]
  end

  erb_files.each do |template|
    # exclude the vendor/ dir
    next if template =~ /vendor/
      Open3.popen3('ruby -Ku -c') do |stdin, stdout, stderr|
      stdin.puts(ERB.new(File.read(template), nil, '-').src)
      stdin.close
      if error = ((stderr.readline rescue false))
        puts template + " - Line " + error[1..-1].sub(/^[^:]*:/, '')
        error_detected = true
      end
      stdout.close rescue false
      stderr.close rescue false
    end
  end
  fail if error_detected
  puts "Done"
  $stdout.flush
end


desc "Run rspec tests, add ci=true for xml output"
task :spec, :directory do |t, args|
  begin
    require 'puppetlabs_spec_helper/rake_tasks'
  rescue LoadError
    fail "Cannot load puppetlabs_spec_helper, did you run ?\n\n  gem install puppetlabs_spec_helper\n"
  end

  args.with_defaults(:directory => "all")
  directory = args[:directory]
  if directory == "all"
    spec_files = FileList['**/spec/**/*_spec.rb']
  else
    spec_files = FileList[ directory + '**/spec/**/*_spec.rb']
  end
  _modules = Array.new
  spec_files.each do |spec|
    _module = File.dirname(File.dirname(spec))
    _modules.push(_module)
  end
  _modules.uniq.each do |rake|
    to_test = File.dirname(rake)
    puts "\nRunning rspec tests from #{to_test}..."
    if ENV['ci'] == nil
      sh %{cd #{to_test}; rake spec SPEC_OPTS="--format documentation"}
    else
      sh %{cd #{to_test}; rake ci:setup:rspec spec}
    end
    $stdout.flush
  end
end


desc "Run rspec tests with xml output"
task :spec_ci do
  ENV['ci'] = 'True'
  Rake::Task[:spec].invoke
end


desc "Check puppet module code style with puppet-lint. Takes in an optional directory, otherwise it checks all"
task :lint, [:directory] do |t, args|
  begin
    require 'puppet-lint'
  rescue LoadError
    fail "Cannot load puppet-lint, did you run :\n\n  gem install puppet-lint\n"
  end

  args.with_defaults(:directory => "all")
  puppet_files = []
  directory = args[:directory]
  if directory == "all"
    puppet_files = FileList['**/*.pp']
  else
    puppet_path = directory + '/**/*.pp'
    puts "Checking out path #{puppet_path}"
    puppet_files = Dir["#{puppet_path}"]
  end

  puts "Running puppet-lint..."
  success = true
  linter = PuppetLint.new
  linter.configuration.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'
  linter.configuration.send("disable_80chars")
  linter.configuration.send("disable_class_inherits_from_params_class")
  linter.configuration.send("disable_puppet_url_without_modules")

  puppet_files.each do |puppet_file|
    puts "Evaluating code style for #{puppet_file}"
    linter.file = puppet_file
    linter.run
    linter.print_problems
    success = false if linter.errors?
  end
  $stdout.flush
  abort "Checking puppet-lint FAILED" if success.is_a?(FalseClass)
  puts "Done"

end


# Psych would be better, but requires ruby 1.9.3, which means rvm, which
# means more complexity.
desc "Validate YAML syntax. Takes in an optional directory, otherwise it checks all"
task :yaml, [:directory] do |t, args|
  begin
    require 'yaml'
  rescue LoadError
    fail "Cannot load yaml, did you run :\n\n  gem install yaml?\n"
  end

  args.with_defaults(:directory => "all")
  yaml_files = []
  directory = args[:directory]
  if directory == "all"
    yaml_files = FileList['**/*.yaml']
  else
    yaml_path = directory + '/**/*.yaml'
    puts "Checking out path #{yaml_path}"
    yaml_files = Dir["#{yaml_path}"]
  end

  puts "Running YAML Parser..."
  success = true

  yaml_files.each do |yaml_file|
    puts "Validating yaml for #{yaml_file}"
    begin
      YAML.parse(File.open("#{yaml_file}"))
    rescue
      puts "YAML syntax error in file: #{yaml_file}"
      success = false
    end
  end
  $stdout.flush
  abort "Validating YAML FAILED" if success.is_a?(FalseClass)
  puts "Done"

end


desc "Creates module documentation."
task :doc do
  print "Generating puppet module documentation..."
  sh %{puppet doc --outputdir html --mode rdoc --modulepath modules --manifest manifests/site.pp}
  puts "Done"
  $stdout.flush
end

