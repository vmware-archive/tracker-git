module TrackerGit
  class Command
    attr_reader :tracker
    def initialize(tracker)
      @tracker = tracker
    end
  end
end