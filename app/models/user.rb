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
  end

  def categories
    #flesh this query out later, or store categories bson
    Array.new
  end

  after_save do |user|
    av = ActionController::Base.new
    user.tweets.reverse.each do |tweet|
      sleep(1)
      message = {:channel => "/" + self.name, :data => {
        :tweet => av.render_to_string(:partial => "user/tweet", :locals => {:tweet => tweet })}
      }
      uri = URI.parse("http://localhost:9292/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
    end
    message = {:channel => "/" + self.name, :data => {:tweet => false} }
    uri = URI.parse("http://localhost:9292/faye")
    puts Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
