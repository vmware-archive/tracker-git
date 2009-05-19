module TrackerGit
  class Command::Finish < Command
    attributes :story_id
    def initialize(story_id)
      @story_id = story_id
    end

    def call(tracker)
      story = tracker.find_story(story_id)
      story[:current_state] = "finished"
      tracker.update_story(story)
    end
  end
end