class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:name]

  enum user_status: { exist: false, withdraw: true }
  has_one_attached :profile_image

  has_many :hobbies,        dependent: :destroy
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites,      dependent: :destroy
  has_many :to_does,        dependent: :destroy
  # フォローする、されるのアソシエーション
  has_many :active_relationships,  class_name: 'Relationship', foreign_key: 'follow_id',   dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # フォロー一覧、フォロワー一覧を持ってくるアソシエーション
  has_many :active_follows,  through: :active_relationships,  source: :follower
  has_many :passive_follows, through: :passive_relationships, source: :follow
  # 自分からの通知、相手からの通知のアソシエーション
  has_many :active_notifications,  class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 15 }
  validates :introduction, length: { maximum: 100 }

  # 名前でのログインを許可
  def self.find_for_database_authentication(warden_conditions)
    name = warden_conditions[:name].to_s
    find_by(name: name)
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def follow(user_id)
    active_relationships.create(follower_id: user_id)
  end

  def unfollow(user_id)
    active_relationships.find_by(follower_id: user_id).destroy
  end

  def active_follow?(user)
    active_follows.include?(user)
  end

  def self.looks(word)
    User.where("name LIKE? OR introduction LIKE?", "%#{word}%","%#{word}%")
  end

  def self.guest
    find_or_create_by!(name: 'guestuser', email: 'guest@example.com', user_status: false, introduction: ゲストでログイン中です) do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def create_notification_follow(current_user)
    notification = current_user.active_notifications.new(
      visited_id: id,
      action: 'follow'
    )
    notification.save if notification.valid?
  end

  def can_display_random?
    return true if last_random_displayed_at.nil?
    last_random_displayed_at < 1.day.ago
  end
end
