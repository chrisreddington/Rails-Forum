class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts, :dependent => :destroy
  has_one :category, :through => :board
end
