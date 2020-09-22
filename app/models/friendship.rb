class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def confirm_friend(user, friend)
    self.confirmed = true
    save
    Friendship.create(user_id: user.id, friend_id: friend.id, confirmed: true)
  end
end
