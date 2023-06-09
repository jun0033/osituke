class Genre < ApplicationRecord
  has_many :hobbies
  
  validates :genre_name, presence: true, uniqueness: true, length: { minimum: 1,maximum: 15 }
end
