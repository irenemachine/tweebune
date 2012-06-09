class UserController < ApplicationController

  def index
  end

  def fetch
    unless @user = User.find_by_name(params["user"])
      begin
        if Twitter.user(params["user"]).protected?
          render :private_user and return
        else
          @user = User.new(:name => params["user"])
        end
      rescue Twitter::Error::NotFound
        render :dne_user and return
      end
    end
    @user.update_tweets
    @user.save
  end
end
