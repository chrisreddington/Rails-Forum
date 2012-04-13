class User < ActiveRecord::Base
  has_secure_password
  
  has_one :profile
  has_many :posts
  has_many :user_conversations
  has_many :conversations, :through => :user_conversations
  has_many :messages, :through => :conversations
  has_many :authentications, :dependent => :destroy
  
  #validates :password, :presence => true, :on => :create, :if => :password_required?
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
                        :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
  
  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    authentications.empty?
  end
end
