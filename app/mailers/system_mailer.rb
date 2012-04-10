class SystemMailer < ActionMailer::Base
  default :from => "system@reddingtons.co.uk"
  
  def welcome_email(user)
    @user = user
    @hash = Digest::SHA1.hexdigest(@user.created_at.to_s + @user.id.to_s)
    @url = "http://forum.reddingtons.co.uk/" + @user.id.to_s + "/confirm/?hash=" + @hash
    mail(:to => user.email, :subject => "Welcome to the Forum")
  end
end
