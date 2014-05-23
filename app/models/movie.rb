class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  
  def self.ratings
	hash = Hash.new
	hash['G'] = 1
	hash['PG'] = 1
	hash['PG-13'] = 1
	hash['R'] = 1
	return hash
  end
end
