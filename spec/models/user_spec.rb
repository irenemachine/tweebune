require 'spec_helper'

describe User do
  describe ".update_tweets" do

    before(:each) do
      @username = "twitter_handle"

      status1 = double("Twitter::Status")
      status2 = double("Twitter::Status")

      status1.stub!(:attrs).and_return({"id_str" => "100"})
      status2.stub!(:attrs).and_return({"id_str" => "102"})

      Twitter.stub!(:user_timeline).with(@username, :count => 200).and_return([status1])
      Twitter.stub!(:user_timeline).with(@username, :count => 200, :since_id => "100").and_return([status2])
      Twitter.stub!(:user_timeline).with(@username, :count => 200, :since_id => "102").and_return([])
    end

    it "updates a user's since_id to the most recent tweet" do
      user = FactoryGirl.create(:user, :name => @username)
      user.since_id.should == "100"
      user.update_tweets
      user.since_id.should == "102"
      user.update_tweets
      user.since_id.should == "102"
    end

    it "is called after a new user is created" do
      user = FactoryGirl.build(:user, :name => @username)
      user.should_receive(:update_tweets)
      user.save
    end
  end
end

