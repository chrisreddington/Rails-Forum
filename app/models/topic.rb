class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts, :dependent => :destroy
end
