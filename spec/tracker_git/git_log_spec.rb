require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module TrackerGit
  describe GitLog do
    describe "#call" do
      it "calls Finish commands for each finish!story_id found in the git logs between the #start_revision and #finish_revision" do
        working_dir = File.expand_path("#{File.dirname(__FILE__)}/../..")
        start_revision, finish_revision = "start_revision", "finish_revision"
        log = GitLog.new(working_dir, start_revision, finish_revision)
        
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

        mock.proxy(Command::Finish).new(111111) do |finish|
          mock.strong(finish).call(tracker)
        end
        mock.proxy(Command::Finish).new(222222) do |finish|
          mock.strong(finish).call(tracker)
        end
        mock.proxy(Command::Finish).new(222223) do |finish|
          mock.strong(finish).call(tracker)
        end
        mock.proxy(Command::Finish).new(333333) do |finish|
          mock.strong(finish).call(tracker)
        end
        mock.proxy(Command::Finish).new(333334) do |finish|
          mock.strong(finish).call(tracker)
        end
        mock.proxy(Command::Finish).new(333335) do |finish|
          mock.strong(finish).call(tracker)
        end

        log.call(tracker)
      end
    end
  end
end