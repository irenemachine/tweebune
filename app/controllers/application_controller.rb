class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :render_error

  def render_error exception
    render "error/e500"
    puts exception
  end
end
