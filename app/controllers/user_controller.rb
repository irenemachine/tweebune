class UserController < ApplicationController
require 'net/http'
require 'json'

  def index
  end

  def fetch
    if @user = User.find_by_name(params["user"])
      @tweets = get_tweets(@user.name, @user.since_id)
    else
      @tweets = get_tweets(params["user"])
      if valid_name?
        @user = User.new(:name => params["user"], :tweets => Array.new, :categories => Array.new)
      end
    end
    unless @tweets.length.eql? 0
      @user.since_id = @tweets[0]["id_str"]
      @user.tweets << @tweets
    end
    @user.save
  end

  def get_tweets username, since_id=nil
    url = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{username}"
    url << "&since_id=#{since_id}" unless since_id.nil?
    JSON.parse(Net::HTTP.get_response(URI(url)).body)
  end

  def valid_name?
    if @tweets.class.name.eql? "Hash" and @tweets["error"] == "Not authorized"
      render :private_user
      return false
    elsif @tweets.class.name.eql? "Array" and @tweets.length.eql? 0
      render :private_user
      return false
    elsif @tweets.class.name.eql? "Hash" and @tweets["error"] == "Not found"
      render :dne_user
      return false
    else
      return true
    end
  end

  def private_user
  end

  def dne_user
  end
end
