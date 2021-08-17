class NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
  end

end
