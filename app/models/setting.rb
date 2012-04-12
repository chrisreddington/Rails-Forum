class Setting < ActiveRecord::Base
  
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :value, :presence => true
end
