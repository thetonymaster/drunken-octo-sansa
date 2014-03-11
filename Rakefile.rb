require 'rubygems'
require 'rake/testtask'

require 'w3c_validators'

include W3CValidators

task :default => [:install_juicer, :test_assets, :minify_css, :minify_js, :build, :test_html]

task :install_juicer do
  sh "juicer install yui_compressor"
  sh "juicer install jslint"
end

task :build do
  sh 'jekyll build'
end

Rake::TestTask.new(:test_html) do |test|
  test.libs << 'test'

  # ensure the sample test file is included here
  test.test_files = FileList['test/html_test.rb', 'test/pagespeed_test.rb']

  test.verbose = true
end

Rake::TestTask.new(:test_assets) do |test|
  test.libs << 'test'

  # ensure the sample test file is included here
  test.test_files = FileList['test/css_test.rb', 'test/js_test.rb']

  test.verbose = true
end


task :deploy do
  Dir.chdir "_site"
  system "git status"
  system "git add ."
  deploy_number = ENV['TRAVIS_BUILD_NUMBER']
  system 'echo "Deploy number: #{deploy_number}"'
  system 'git commit -am "Deploy #{deploy_number}"'
  system 'git push' 
end

task :minify_css do
  Dir.glob("**/*.css").each do |f|
    unless f.end_with? ".min.css" 
      sh "juicer merge #{f} --force"
    end
  end
end


task :minify_js do
  Dir.glob("**/*.js").each do |f|
    unless f.end_with? '.min.js' 
      sh "juicer merge #{f} --force"
    end
  end
end
