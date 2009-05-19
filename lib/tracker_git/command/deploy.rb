module TrackerGit
  class Command::Deploy < Command
    def self.call(tracker)
      if system("cap demo deploy")
        tracker.find({"current_state" => "finished"}).each do |story|
          tracker.update_story(story.merge("current_state" => "delivered"))
        end
      end
    end
  end
end