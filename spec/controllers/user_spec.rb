require 'spec_helper'

describe UserController do
  describe "fetch" do
    it "does not create a user if the twitter handle is private" do
      username = "private"
      user = double("Twitter::User")
      Twitter.stub!(:user).with(username).and_return(user)
      user.stub!(:protected?).and_return(true)

      lambda {post 'fetch', "user" => username}.should raise_error
      User.find_by_name(username).should == nil
    end
    it "does not create a user if the twitter handle does not exist" do
      username = "dne"
      error = double("Twitter::Error::NotFound")
      user = double("Twitter::User")
      Twitter.stub!(:user).with(username).and_return(user)
      user.stub!(:protected?).and_return(error)

      lambda {post 'fetch', "user" => username}.should raise_error
      User.find_by_name(username).should == nil
    end
    it "creates a user if the twitter handle is public" do
      username = "public"
      user = double("Twitter::User")
      status1 = double("Twitter::Status")
      status1.stub!(:attrs).and_return({"id_str" => "100"})
      Twitter.stub!(:user_timeline).with(username, :count => 200).and_return([status1])
      Twitter.stub!(:user).with(username).and_return(user)
      user.stub!(:protected?).and_return(false)

      lambda {post 'fetch', "user" => username}.should raise_error
      User.find_by_name(username).name.should == username
    end
  end
end
