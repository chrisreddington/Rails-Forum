class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  
  validates :content, :presence => true
  validates :topic_id, :presence => true
end
