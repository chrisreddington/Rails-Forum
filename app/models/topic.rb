class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts, :dependent => :destroy
  has_one :category, :through => :board
  
  accepts_nested_attributes_for :posts
  
  validates :name, :presence => true
end
