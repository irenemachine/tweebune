class UserController < ApplicationController

  def index
  end

  def fetch
    if @user = User.find_by_name(params["user"])
      @user.update_tweets
    else
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
    @user.save
  end
end
