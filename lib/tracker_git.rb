require "git"
require "auto_tagger"
require "logger"
dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../vendor/ruby-pivotal-tracker/pivotal_tracker")

module TrackerGit
  class << self
    attr_accessor :user_token, :project_id
  end
end

require "#{dir}/tracker_git/git_log"
require "#{dir}/tracker_git/command"
Dir["#{dir}/tracker_git/command/*.rb"].each do |file|
  require file
end
