require 'mongo_mapper'
class User
  include MongoMapper::Document

  key :name, String
  key :since_id, String
  many :tweets
  many :categories


  after_create :update_tweets

  def update_tweets
    puts "update_tweets"
    tweets = self.since_id ? Twitter.user_timeline(self.name, :count => 200, :since_id => self.since_id) : Twitter.user_timeline(self.name, :count => 200)
    puts tweets.length
    if tweets.length > 0
      self.since_id = tweets[0].attrs["id_str"]
      tweets.each do |tweet|
        self.tweets << Tweet.new(tweet.attrs)
      end
    end
  end
end
