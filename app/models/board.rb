class Board < ActiveRecord::Base
  belongs_to :category
  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics
  
  # app/models/forum.rb  
  def most_recent_post  
    topic = Topic.first(:order => 'last_post_at DESC', :conditions => ['board_id = ?', self.id])  
    return topic  
  end
end
