module Recommendations
  module Similarity
    class EuclideanDistanceSimilarity
      def initialize(data_model)
         @data_model = data_model
      end

      def user_similarity(user_1, user_2)
        user_1_preferences = @data_model.preferences_for_user(user_1)
        preferences = @data_model.preferences
        sum = 0
        user_1_preferences.each do |preference|
          if(preferences.for_user_item(user_2,preference.item))
            diff = preference.preference - preferences.for_user_item(user_2,preference.item).preference
            sum += diff*diff
          end
        end
        max_common_items = [user_1_preferences.size, preferences.size].min
        1.0 / (1.0 + Math.sqrt(sum) / Math.sqrt(max_common_items));
      end
    end
  end
end