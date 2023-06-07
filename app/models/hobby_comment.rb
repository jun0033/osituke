class HobbyComment < ApplicationRecord
  belongs_to :hobby
  belongs_to :user

  validates :comment, presence: true, length: { minimum: 1,maximum: 500 }
end
