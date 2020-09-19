class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :friendships
  has_many :inverse_friendships, foreign_key: 'friend_id', class_name: 'Friendship'

  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  has_many :sent_requests, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :sent_requests, source: :friend

  has_many :pending_requests, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :pending_requests, source: :user

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def friends_and_own_posts
    Post.where(user: (self.friends + [self]))
  end

  def find_friendship(user)
    self.friendships.find_by(friend_id: user.id)
  end

  def find_received(friend_id)
    inverse_friendships.where(confirmed: false).find_by(user_id: friend_id)
  end

  def find_sent(friend_id)
    friendships.where(confirmed: false).find_by(friend_id: friend_id)
  end

  def delete_mutual_friendship(friend)
    self.find_friendship(friend).destroy
    friend.find_friendship(self).destroy    
  end

  def create_friendship(friend)
    friendships.create(friend_id: friend, confirmed: false)
  end
end
