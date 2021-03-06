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

  def friendship_button(user, friend)
    @current_user = user
    @user = friend
    sent = Friendship.where(user_id: user.id, friend_id: friend.id)
    received = Friendship.where(user_id: friend.id, friend_id: user.id)
    received_accepted = received.first.confirmed.eql?(true) unless received.empty?
    sent_accepted = sent.first.confirmed.eql?(true) unless sent.empty?
    if !sent.empty? && !sent_accepted && received.empty?
      render partial: 'cancel_invitation', locals: { user: @user }
    elsif !sent.empty? && sent_accepted && received.empty?
      render partial: 'unfriend', locals: { user: @user, current_user: @current_user }
    elsif !received.empty? && !received_accepted
      render partial: 'check_request'
    elsif !received.empty? && received_accepted
      render partial: 'unfriend', locals: { user: @user, current_user: @current_user }
    elsif sent.empty? && received.empty?
      render partial: 'send_invitation'
    end
  end

  def your_friends_link
    html = ''
    html << "#{menu_link_to 'Your Friends', user_friends_path(current_user)} " if current_user
    html.html_safe
  end

  def requests_link
    html = ''
    html << "#{menu_link_to 'Requests', user_friendships_path(current_user)} " if current_user
    html.html_safe
  end
end
