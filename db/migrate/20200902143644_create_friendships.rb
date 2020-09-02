class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      #do a test with this configuration, used create_likes as reference. Remember the problem you had with adding foreign_keys instantly
      t.integer :friend1_id
      t.integer :friend2_id
      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :friend1_id
    add_foreign_key :friendships, :users, column: :friend2_id
  end
end
