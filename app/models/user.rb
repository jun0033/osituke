class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :hobbies, dependent: :destroy
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
