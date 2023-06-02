class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_status: { exist: false, withdraw: true }

  has_many :hobbies, dependent: :destroy
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # フォローする、されるのアソシエーション
  has_many :relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォロー一覧、フォロワー一覧を持ってくるアソシエーション
  has_many :active_follows, through: :relationships, source: :follower
  has_many :passive_follows, through: :reverse_of_relationships, source: :follow
end
