require "git"
require "auto_tagger"

module TrackerGit
end

dir = File.dirname(__FILE__)
require "#{dir}/tracker_git/git_log"
require "#{dir}/tracker_git/command"
Dir["#{dir}/tracker_git/command/*.rb"].each do |file|
  require file
end
