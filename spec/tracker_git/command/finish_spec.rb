require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

module TrackerGit
  describe Command::Finish do
    describe "#call" do
      it "updates Story to have a state of finished" do
        story_id = 55999
        story = {:id => story_id, :current_state => "started", :other_field => "foobar"}
        tracker = Tracker.new
        mock.strong(tracker).find_story(story_id) {story}
        mock.strong(tracker).update_story(story.merge(:current_state => "finished"))
        Command::Finish.call(tracker, story_id)
      end
    end
  end
end