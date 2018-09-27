class Movie < ActiveRecord::Base
    def self.mpaa_ratings
        self.select(:rating).map(&:rating).uniq
    end
end
