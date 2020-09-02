class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :friendships, -> (user) {where "friend1_id = ? OR friend2_id = ?", user.id, user.id }
  has_many :friends, through: :friendships
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
