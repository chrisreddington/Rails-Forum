class SystemMailer < ActionMailer::Base
  default :from => @system_email
  
  def welcome_email(user)
    @user = user
    @hash = Digest::SHA1.hexdigest(@user.created_at.to_s + @user.id.to_s)
    @url = @title + "http://forum.reddingtons.co.uk/users/" + @user.id.to_s + "/confirm/?hash=" + @hash
    mail(:to => user.email, :subject => "Welcome to #{@title}")
  end
end
