class Movie < ActiveRecord::Base
    
    def self.all_ratings
        ['G', 'PG', 'PG-13', 'R']
    end

    def self.with_ratings(rating_list)
        if rating_list.empty?
            Movie.all
        else
            Movie.where("rating IN (?)", rating_list)
        end
    end
end
