require "rubygems"
require "spec"
require "spec/autorun"
require "rr"
dir = File.dirname(__FILE__)
$:.unshift(File.expand_path("#{dir}/../lib"))
require "tracker_git"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

class Spec::ExampleGroup
end