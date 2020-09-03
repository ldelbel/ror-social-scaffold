class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :friendships_as_requester, foreign_key: 'friend1_id', class_name: 'Friendship'
  has_many :friendships_as_receiver, foreign_key: 'friend2_id', class_name: 'Friendship'
  has_many :friends2, through: :friendships_as_requester, source: :friend2
  has_many :friends1, through: :friendships_as_receiver, source: :friend1

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def friends
    friends1 + friends2
  end
end
