require 'mongo'
require_relative '../../../lib/recommendations/model/preference'
require_relative '../../../lib/recommendations/model/preferences'
module Recommendations
  module DataModel
    class MongoDataModel
      DEFAULT_HOST = "localhost"
      DEFAULT_PORT = 27017
      def initialize(conf)
        @collection = Mongo::Connection.new(conf[:host] || DEFAULT_HOST, conf[:port] || DEFAULT_PORT).db(conf[:db])[conf[:collection]]
      end

      def preferences_for_user(user)
        results = @collection.find({:user_id => user})
        extract_results_into_preferences(results)
      end

      def preference_for_user_and_item(user, item)
        results = @collection.find({:user_id => user, :item_id => item})
        extract_results_into_preferences(results)[0]
      end

      def items_for_users(users)
        set = Set.new
        users.each do |user|
          preferences = preferences_for_user(user)
          set.merge(preferences.map { |pref| pref.item })
        end
        set.to_a
      end

      def users
        results = @collection.find()
        results.map do |preference|
          preference["user_id"]
        end
      end

      def preferences
        results = @collection.find
        extract_results_into_preferences(results)
      end

      private
      def extract_results_into_preferences(results)
        preferences = Recommendations::Model::Preferences.new
        results.each do |row|
          preferences << Recommendations::Model::Preference.new(row['user_id'], row['item_id'], row['preference'])
        end
        preferences
      end
    end
  end
end