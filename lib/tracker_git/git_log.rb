module TrackerGit
  class GitLog
    attr_reader :working_directory, :start_revision, :finish_revision
    def initialize(working_directory, start_revision, finish_revision)
      @working_directory, @start_revision, @finish_revision = working_directory, start_revision, finish_revision
    end

    def parse
      git = Git.open(working_directory, :log => Logger.new(STDOUT))
      commits = git.log.between(start_revision, finish_revision)

      commands = []

      finish_regexp = Regexp.new("finish!([0-9]+)")
      commits.each do |commit|
        matches = finish_regexp.match(commit.message)
        if matches
          commands << Command::Finish.new(matches[1].to_i)
        end
      end
      
      commands
    end
  end
end