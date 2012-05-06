module Recommendations
  module Model
    class Preference
      attr_reader :user, :item, :preference
      def initialize(user, item, preference)
        @user = user
        @item = item
        @preference = preference
      end
    end
  end
end