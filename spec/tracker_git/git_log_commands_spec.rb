require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module TrackerGit
  describe GitLogCommands do
    describe "#call" do
      it "calls Finish commands for each finish!story_id found in the git logs between the #start_revision and #finish_revision" do
        working_dir = File.expand_path("#{File.dirname(__FILE__)}/../..")
        start_revision, finish_revision = "start_revision", "finish_revision"
        log = GitLogCommands.new(working_dir, start_revision, finish_revision)
        
        mock.proxy(Git).open(working_dir, is_a(Hash)) do |git|
          mock.proxy(git).log do |log|
            mock.strong(log).between(start_revision, finish_revision) do
              [
                Git::Object::Commit.new("base0", "sha0", 'message' => "finish!111111", 'parent' => ['sha-1']),
                Git::Object::Commit.new("base1", "sha1", 'message' => "finish!222222 and finish!222223", 'parent' => ['sha0']),
                Git::Object::Commit.new("base2", "sha2", 'message' => "", 'parent' => ['sha1']),
                Git::Object::Commit.new("base3", "sha3", 'message' => "finish!333333,333334,333335", 'parent' => ['sha2']),
              ]
            end
          end
        end

        tracker = Tracker.new

        mock.strong(Command::Finish).call(tracker, 111111).ordered
        mock.strong(Command::Finish).call(tracker, 222222).ordered
        mock.strong(Command::Finish).call(tracker, 222223).ordered
        mock.strong(Command::Finish).call(tracker, 333333).ordered
        mock.strong(Command::Finish).call(tracker, 333334).ordered
        mock.strong(Command::Finish).call(tracker, 333335).ordered

        log.call(tracker)
      end

      it "calls Deploy command only once, even if requested in multiple commits and multiple times in the same commit" do
        pending
      end

      it "calls Deploy command after all the Finish commands have run" do
        pending
      end
    end
  end
end