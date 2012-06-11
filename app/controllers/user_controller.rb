class UserController < ApplicationController

  def index
  end

  def fetch
    user = params["user"].gsub(/@/, "")
    unless @user = User.find_by_name(user)
      begin
        if Twitter.user(user).protected?
          render :private_user and return
        else
          @user = User.new(:name => user)
        end
      rescue Twitter::Error::NotFound
        render :dne_user and return
      end
    end
    @user.update_tweets
    @user.save
    render :nothing => true
  end
end
