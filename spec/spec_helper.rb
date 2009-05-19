require "rubygems"
require "spec"
require "spec/autorun"
require "rr"

Spec::Runner.configure do |config|
  config.mock_with :rr
end
