class Hobby < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :tag, optional: true
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many_attached :hobby_images

  def get_hobby_image(width, height)
    hobby_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(word)
    Hobby.where("title LIKE? OR body LIKE?", "%#{word}%","%#{word}%")
  end
end
