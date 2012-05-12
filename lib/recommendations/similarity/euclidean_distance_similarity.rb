module Recommendations
  module Similarity
    class EuclideanDistanceSimilarity
      def initialize(data_model)
        @data_model = data_model
      end

      def user_similarity(user_1, user_2)
        user_1_preferences = @data_model.preferences_for_user(user_1)
        return 0 if user_1_preferences.empty?
        sum = 0
        user_1_preferences.each do |preference|
          other_user_preference = @data_model.preference_for_user_and_item(user_2, preference.item)
          if (other_user_preference)
            diff = preference.preference.to_f - other_user_preference.preference.to_f
            sum += diff*diff
          end
        end
        max_common_items = user_1_preferences.size
        1.0 / (1.0 + Math.sqrt(sum) / Math.sqrt(max_common_items));
      end
    end
  end
end