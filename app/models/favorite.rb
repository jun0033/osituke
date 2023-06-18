class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :hobby

  def create_notification_favorite(current_user)
    # すでに「ナイス趣味」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and hobby_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # ナイス趣味されていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        hobby_id: hobby.id,
        visited_id: hobby.user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するナイス趣味の場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
