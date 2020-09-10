module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def friendship_button(user,friend)
    html = ""
    sent = Friendship.where(friend1_id: user.id, friend2_id: friend.id)
    received = Friendship.where(friend1_id: friend.id, friend2_id: user.id)
    if !sent.empty? && received.empty?  
      return render partial: 'cancel_invitation'
    elsif !received.empty?
       render partial: 'check_request'
    elsif sent.empty? && received.empty?
     return render partial: 'send_invitation'
    end
    
  end
end
