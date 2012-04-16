class Conversation < ActiveRecord::Base
  has_many :user_conversations
  has_many :users, :through => :user_conversations
  has_many :messages


  validates :subject, :presence => true
  accepts_nested_attributes_for :messages
end