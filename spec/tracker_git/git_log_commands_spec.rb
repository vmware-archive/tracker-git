require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module TrackerGit
  describe GitLogCommands do
    attr_reader :log
    before do
      working_dir = File.expand_path("#{File.dirname(__FILE__)}/../..")
      start_revision, finish_revision = "start_revision", "finish_revision"
      @log = GitLogCommands.new(working_dir, start_revision, finish_revision)

      mock.proxy(Git).open(working_dir, is_a(Hash)) do |git|
        mock.proxy(git).log do |log|
          mock.strong(log).between(start_revision, finish_revision) do
            commits
          end
        end
      end
    end

    def commits
      []
    end

    describe "#call" do

      describe "Finish commands" do
        def commits
          [
            Git::Object::Commit.new("base0", "sha0", 'message' => "finish!111111", 'parent' => ['sha-1']),
            Git::Object::Commit.new("base1", "sha1", 'message' => "finish!222222 and finish!222223", 'parent' => ['sha0']),
            Git::Object::Commit.new("base2", "sha2", 'message' => "", 'parent' => ['sha1']),
            Git::Object::Commit.new("base3", "sha3", 'message' => "finish!333333,333334,333335", 'parent' => ['sha2']),
          ]
        end

        it "calls Finish commands for each finish!story_id found in the git logs between the #start_revision and #finish_revision" do
          mock.strong(Command::Finish).call(tracker, 111111).ordered
          mock.strong(Command::Finish).call(tracker, 222222).ordered
          mock.strong(Command::Finish).call(tracker, 222223).ordered
          mock.strong(Command::Finish).call(tracker, 333333).ordered
          mock.strong(Command::Finish).call(tracker, 333334).ordered
          mock.strong(Command::Finish).call(tracker, 333335).ordered

          log.call(tracker)
        end
      end

      describe "Deploy Commands" do
        context "when Deploy commands are requested in multiple commits and multiple times in the same commit" do
          def commits
            [
              Git::Object::Commit.new("base0", "sha0", 'message' => "deploy!", 'parent' => ['sha-1']),
              Git::Object::Commit.new("base1", "sha1", 'message' => "", 'parent' => ['sha0']),
              Git::Object::Commit.new("base3", "sha3", 'message' => "deploy!", 'parent' => ['sha2']),
            ]
          end
          it "calls Deploy command only once" do
            mock.strong(Command::Deploy).call(tracker)

            log.call(tracker)
          end
        end

        context "when there are both Finish and a Deploy command" do
          def commits
            [
              Git::Object::Commit.new("base0", "sha0", 'message' => "deploy!", 'parent' => ['sha-1']),
              Git::Object::Commit.new("base1", "sha1", 'message' => "finish!111111", 'parent' => ['sha0']),
              Git::Object::Commit.new("base3", "sha3", 'message' => "finish!222222", 'parent' => ['sha2']),
            ]
          end

          it "calls the Deploy command last" do
            mock.strong(Command::Finish).call(tracker, 111111).ordered
            mock.strong(Command::Finish).call(tracker, 222222).ordered
            mock.strong(Command::Deploy).call(tracker).ordered

            log.call(tracker)
          end
        end
      end

    end
  end
end