class User < ActiveRecord::Base
  has_secure_password
  has_one :profile
  has_many :posts
  validates_presence_of :password, :on => :create
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
                        :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }, :on => [:create, :update]
end
