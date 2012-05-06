module Recommendations
  module Similarity
    module Neighborhood
      class NearestNUserNeighborhood
        def initialize(data_model, similarity, n_of_neighbors, min_similarity)
          @data_model = data_model
          @similarity = similarity
          @n_of_neighbors = n_of_neighbors
          @min_similarity = min_similarity
        end

        def user_neighborhood(user)
            users = @data_model.users
            similarities = {}
            users.each do |other_user|
              next if user == other_user
              similarities[other_user] = @similarity.user_similarity(user,other_user)
            end
          similarities.delete_if{|k,value| value < @min_similarity}.sort_by {|k,v| v}.map{|k,v|k}.reverse.first(@n_of_neighbors)
        end
      end
    end
  end
end