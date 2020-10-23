class Movie < ActiveRecord::Base
    
    def self.all_ratings
        ['G', 'PG', 'PG-13', 'R']
    end

    def self.with_ratings(rating_list, sort)
        Movie.where("upper(rating) IN (?)", rating_list).order(sort)
    end
end
