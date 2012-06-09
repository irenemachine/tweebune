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

      tweet1 = FactoryGirl.create(:tweet)
      tweet1.stub!(:analysis).and_return(tweet1)
      Tweet.stub!(:new).and_return(tweet1)
    end

    it "stores new tweets retrieved and updates since_id to the most recent tweet retrieved from the API" do
      user = FactoryGirl.create(:user, :name => @username)
      user.tweets.count.should == 0
      user.since_id.should be_nil
      user.update_tweets
      user.tweets.count.should == 1
      user.since_id.should == "100"
    end

    it "does nothing if no new tweets are retrieved from the API" do
      user = FactoryGirl.create(:user, :name => @username)
      user.update_tweets
      user.update_tweets
      user.tweets.count.should == 2
      user.since_id.should == "102"
      user.update_tweets
      user.tweets.count.should == 2
      user.since_id.should == "102"
    end
  end
end

