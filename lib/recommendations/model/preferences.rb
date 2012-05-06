module Recommendations
  module Model
    class Preferences
      include Enumerable
      def initialize
        @by_user={}
        @by_item={}
        @by_user_item={}
        @preferences = []
      end

      def <<(preference)
        (@by_user[preference.user] ||= []) << preference
        (@by_item[preference.item] ||= []) << preference
        (@by_user_item[preference.user] ||= {})[preference.item] = preference
        @preferences << preference
        self
      end

      def for_user(user)
        prefs = Preferences.new
        @by_user[user].each do|preference|
          prefs << preference
        end
        prefs
      end

      def for_item(item)
        prefs = Preferences.new
        @by_item[item].each do |preference|
          prefs << preference
        end
        prefs
      end

      def for_user_item(user,item)
        @by_user_item[user][item]
      end

      def each
        @preferences.each do|preference|
          yield preference
        end
      end

      def size
        @preferences.size
      end

      def [](index)
        @preferences[index]
      end
    end
  end
end