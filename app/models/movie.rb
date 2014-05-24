class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  
  def self.ratings
	hash = Hash.new
	hash['G'] = true
	hash['PG'] = true
	hash['PG-13'] = true
	hash['R'] = true
	return hash
  end
  
end
