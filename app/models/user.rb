require 'mongo_mapper'
class User
  include MongoMapper::Document

  safe

  key :name, String
  key :since_id, String
  many :tweets

  def update_tweets
    tweets = self.since_id ? Twitter.user_timeline(self.name, :count => 200, :since_id => self.since_id) : Twitter.user_timeline(self.name, :count => 200)
    if tweets.length > 0
      self.since_id = tweets[0].attrs["id_str"]
      tweets.each do |tweet|
        tweet.attrs.delete("user")
        tweet.attrs.delete("source")
        tweet.attrs.delete("id")
        tweet.attrs.delete("in_reply_to_status_id")
        tweet.attrs.delete("in_reply_to_user_id")
        self.tweets << Tweet.new(tweet.attrs).analysis
      end
    end
    self.save
  end

  def categories
    #flesh this query out later, or store categories bson
    Array.new
  end
end
