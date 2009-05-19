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

      finish_regexp = Regexp.new("finish!([0-9,]+)")
      commits.each do |commit|
        commit.message.gsub(finish_regexp) do |occurrences|
          finish_regexp.match(occurrences)[1].split(",").each do |occurrence|
            commands << Command::Finish.new(occurrence.to_i)
          end
        end
      end
      
      commands
    end
  end
end