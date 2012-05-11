class UserController < ApplicationController

  def index
  end

  def fetch
    @user = params["user"]
  end
end
