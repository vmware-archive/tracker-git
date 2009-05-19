require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module TrackerGit
  describe Command do
    describe "#==" do
      it "returns true when the other's attribute values match" do
        Command::Finish.new(12345).should == Command::Finish.new(12345)
        Command::Finish.new(12345).should_not == Command::Finish.new(1111)
      end
    end
  end
end