module PostsHelper
  def user_info(post)
    @user = User.find_by_id(post.user_id)
   raw("<p>#{image_tag(avatar_url(@user))}</p>" + "<p>#{link_to(@user.username, @user)}</p>" + "<p>#{post.created_at.to_time().to_s}</p>")
  end
end
