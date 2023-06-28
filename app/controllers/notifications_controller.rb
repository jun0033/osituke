class NotificationsController < ApplicationController
  def index
    @notifications       = current_user.passive_notifications
    @notifications_index = @notifications.where.not(visitor_id: current_user.id)
    # 通知を閲覧済みに変更
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
