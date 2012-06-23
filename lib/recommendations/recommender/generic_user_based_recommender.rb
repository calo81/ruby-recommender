require_relative '../../../lib/recommendations/model/recommended_item'
require_relative '../../../lib/caching/cacheable'
module Recommendations
  module Recommender
    class GenericUserBasedRecommender
      include Cacheable
      def initialize(data_model, similarity, neighborhood, rating_estimator)
        @data_model = data_model
        @similarity = similarity
        @neighborhood = neighborhood
        @rating_estimator = rating_estimator
      end

      def recommend(user, n_recommendations)
        neighbors = @neighborhood.user_neighborhood(user)
        all_items = @data_model.items_for_users(neighbors)
        reviewed_items = @data_model.items_for_users([user])
        potential_items = all_items - reviewed_items
        recommendations = []
        potential_items.each do |item|
          estimated_value = @rating_estimator.estimate(user, neighbors, item)
          recommendations <<  Recommendations::Model::RecommendedItem.new(item,estimated_value)
        end
        recommendations.sort_by {|recommendation| recommendation.value}.reverse.first(n_recommendations)
      end

      def set_preference(user,item,value)
        @data_model.set_preference(user,item,value)
      end

      cacheable :recommend
    end
  end
end