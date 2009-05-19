module TrackerGit
  class Command::Finish < Command
    def call(story_id)
      story = tracker.find_story(story_id)
      story[:current_state] = "finished"
      tracker.update_story(story)
    end
  end
end