module Recommendations
  module Recommender
    module Estimation
      class DefaultRatingEstimator
        def initialize(data_model, similarity)
          @data_model = data_model
          @similarity = similarity
        end

        def estimate(user, neighbors, item)
          pref = 0.0
          total_similarity = 0.0
          count = 0
          neighbors.each do |neighbor|
            next unless preference_user_item = @data_model.preference_for_user_and_item(neighbor, item)
            similarity = @similarity.user_similarity(user, neighbor)
            preference = preference_user_item.preference
            pref += similarity * preference.to_f
            total_similarity += similarity
            count +=1
          end
          pref / total_similarity
        end
      end
    end
  end
end