class HobbyTag < ApplicationRecord
  belongs_to :hobby
  belongs_to :tag
  validates :hobby_id, presence: true
  validates :tag_id,   presence: true
end
