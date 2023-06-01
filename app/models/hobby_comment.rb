class HobbyComment < ApplicationRecord
  belongs_to :hobby
  belongs_to :user
end
