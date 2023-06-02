class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_status: { exist: false, withdraw: true }
  has_one_attached :profile_image

  has_many :hobbies, dependent: :destroy
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # フォローする、されるのアソシエーション
  has_many :relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォロー一覧、フォロワー一覧を持ってくるアソシエーション
  has_many :active_follows, through: :relationships, source: :follower
  has_many :passive_follows, through: :reverse_of_relationships, source: :follow

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def follow(user_id)
    relationships.create(follow_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(follow_id: user_id).destroy
  end

  def active_follow?(user)
    active_follow.include?(user)
  end
end
