class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @microposts = Micropost.all
      @feed_items = current_user.feed
    end
  end

  def about
  end

  def help
  end
end
