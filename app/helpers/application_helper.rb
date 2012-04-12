module ApplicationHelper
  def avatar_url(user)
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png"
    end
    
    def latest_post(post)
      if post
        @user = User.find_by_id(post.user_id)
        raw("<p>#{link_to(post.topic.name, post.topic)} by #{link_to(@user.username, @user)} #{distance_of_time_in_words_to_now post.created_at} ago</p>")
      else
        "No posts"
      end
    end
    
    def user_message_count
      return UserConversation.count(:conditions => ['read != ? and user_id = ?', true, current_user.id]).to_s
    end
end