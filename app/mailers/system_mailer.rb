class SystemMailer < ActionMailer::Base
  default :from => system@forum.reddingtons.co.uk
  
  def welcome_email(user)
    @user = user
    @title = Setting.find_by_name('title').value
    @hash = Digest::SHA1.hexdigest(@user.created_at.to_s + @user.id.to_s)
    @url = Setting.find_by_name('domain_name').value + "/users/" + @user.id.to_s + "/confirm/?hash=" + @hash
    mail(:to => user.email, :subject => "Welcome to #{Setting.find_by_name('title').value}")
  end
end
