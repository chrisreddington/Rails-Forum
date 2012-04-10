class SystemMailer < ActionMailer::Base
  default :from => "system@reddingtons.co.uk"
  
  def welcome_email(user)
    @user = user
    @url = "http://example.com/login"
    mail(:to => user.email, :subject => "Welcome to the Forum")
  end
end
