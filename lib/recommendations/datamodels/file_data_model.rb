require_relative '../model/preference'
require_relative '../model/preferences'
require 'set'
module Recommendations
  module DataModel
    class FileDataModel
      attr_reader :preferences, :users
      def initialize(file_path)
        @preferences = Recommendations::Model::Preferences.new
        @users = Set.new
        File.open(file_path, 'r') do |file|
          file.each_line do |line|
            line_split = line.split(",")
            @preferences << Recommendations::Model::Preference.new(line_split[0], line_split[1], line_split[2].chomp.to_i)
            @users << line_split[0]
          end
        end
      end

      def preferences_for_user(user)
        @preferences.for_user(user)
      end

      def preference_for_user_and_item(user, item)
        @preferences.for_user_item(user, item)
      end

      def items_for_users(users)
        set = Set.new
        users.each do |user|
          preferences = @preferences.for_user(user)
          set.merge(preferences.map{|pref| pref.item})
        end
        set.to_a
      end
    end
  end
end