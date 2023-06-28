class HobbyTag < ApplicationRecord
  belongs_to :hobby,    optional: true
  belongs_to :tag,      optional: true
  validates :hobby_id, presence: true
  validates :tag_id,   presence: true
end
