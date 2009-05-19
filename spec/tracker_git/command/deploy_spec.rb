require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

module TrackerGit
  describe Command::Deploy do
    describe "#call" do
      it "calls system command `cap demo deploy`" do
        mock(Command::Deploy).system("cap demo deploy")

        Command::Deploy.call(tracker)
      end

      context "when system command passes" do
        it "delivers all finished stories" do
          finished_stories = [
            {'id' => 1, 'current_state' => 'finished'},
            {'id' => 3, 'current_state' => 'finished'},
          ]

          mock.strong(tracker).find({"current_state" => "finished"}) do
            finished_stories
          end

          finished_stories.each do |finished_story|
            mock.strong(tracker).update_story(finished_story.merge('current_state' => 'delivered'))
          end

          mock(Command::Deploy).system("cap demo deploy") {true}
          Command::Deploy.call(tracker)
        end
      end

      context "when system command fails" do
        it "does not deliver stories" do
          dont_allow(tracker).find({"current_state" => "finished"})

          mock(Command::Deploy).system("cap demo deploy") {false}
          Command::Deploy.call(tracker)
        end
      end
    end
  end
end