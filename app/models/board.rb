class Board < ActiveRecord::Base
  belongs_to :category
  has_many :topics, :dependent => :destroy
end
