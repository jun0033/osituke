class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications
    @notifications_index = @notifications.where.not(visitor_id: current_user.id)
    # @hobby_comment = HobbyComment.find(notification.hobby_comment_id)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
