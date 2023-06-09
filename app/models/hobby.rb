class Hobby < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many   :hobby_tags,     dependent: :destroy
  has_many   :tags,           through:   :hobby_tags
  has_many   :hobby_comments, dependent: :destroy
  has_many   :favorites,      dependent: :destroy
  has_many   :to_does,        dependent: :destroy
  has_many   :notifications,  dependent: :destroy

  has_many_attached :hobby_images
  # クラス外部からのインスタンス変数へのアクセスを許可
  attr_accessor :tag_name

  with_options presence: true, on: :publicize do
    validates :title, length: { minimum: 1,maximum: 30 }
    validates :body,  length: { minimum: 1,maximum: 500 }
  end
  validates :tag_name, length: { maximum: 100 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def checked_by?(user)
    to_does.exists?(user_id: user.id)
  end

  def self.looks(word)
    Hobby.where("title LIKE? OR body LIKE?", "%#{word}%","%#{word}%")
  end

  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
      current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
      old_tags     = current_tags   - sent_tags
      new_tags     = sent_tags.uniq - current_tags

      # タグの追加と削除を一連の操作としてまとめる
      ActiveRecord::Base.transaction do
        # 古いタグを消す
        old_tags.each do |old|
          self.tags.destroy
          Tag.find_by(tag_name: old)
        end

        # 新しいタグを保存
        new_tags.each do |new|
          new_post_tag = Tag.find_or_create_by(tag_name: new)
          self.tags << new_post_tag
        end
     end
  end

  def done_by?(user)
    hobby_comments.done.exists?(user_id: user.id)
  end
end
