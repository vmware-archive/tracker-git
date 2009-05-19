module TrackerGit
  class GitLogCommands
    attr_reader :working_directory, :start_revision, :finish_revision
    def initialize(working_directory, start_revision, finish_revision)
      @working_directory, @start_revision, @finish_revision = working_directory, start_revision, finish_revision
    end

    def call(tracker)
      commits = get_commits
      call_finish_commands(commits, tracker)
    end

    protected

    def get_commits
      git = Git.open(working_directory, :log => Logger.new(STDOUT))
      git.log.between(start_revision, finish_revision)
    end

    def call_finish_commands(commits, tracker)
      finish_regexp = Regexp.new("finish!([0-9,]+)")
      commits.each do |commit|
        commit.message.gsub(finish_regexp) do |occurrences|
          finish_regexp.match(occurrences)[1].split(",").each do |occurrence|
            Command::Finish.call(tracker, occurrence.to_i)
          end
        end
      end
    end
  end
end