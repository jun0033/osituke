class Tag < ApplicationRecord
  has_many :hobby_tags, dependent: :destroy
  has_many :hobbies,    through:   :hobby_tags

  validates :tag_name, presence: true, uniqueness: true, length: { minimum: 1,maximum: 100 }
end
