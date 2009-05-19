require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module TrackerGit
  describe GitLog do
    describe "#parse" do
      it "returns an array of Finish commands for each finish!story_id found in the git logs between the #start_revision and #finish_revision" do
        working_dir = File.expand_path("#{File.dirname(__FILE__)}/../..")
        start_revision, finish_revision = "start_revision", "finish_revision"
        log = GitLog.new(working_dir, start_revision, finish_revision)
        
        mock.proxy(Git).open(working_dir, is_a(Hash)) do |git|
          mock.proxy(git).log do |log|
            mock.strong(log).between(start_revision, finish_revision) do
              [
                Git::Object::Commit.new("base0", "sha0", 'message' => "finish!111111", 'parent' => ['sha-1']),
                Git::Object::Commit.new("base1", "sha1", 'message' => "finish!222222", 'parent' => ['sha0']),
                Git::Object::Commit.new("base2", "sha2", 'message' => "", 'parent' => ['sha1']),
                Git::Object::Commit.new("base3", "sha3", 'message' => "finish!333333", 'parent' => ['sha2']),
              ]
            end
          end
        end

        log.parse.should == [
          Command::Finish.new(111111),
          Command::Finish.new(222222),
          Command::Finish.new(333333),
        ]
      end
    end
  end
end