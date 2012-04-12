class User < ActiveRecord::Base
  has_secure_password
  
  has_one :profile
  has_many :posts
  has_many :user_conversations
  has_many :conversations, :through => :user_conversations
  has_many :messages, :through => :conversations
  
  validates_presence_of :password, :on => :create
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
                        :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
end
