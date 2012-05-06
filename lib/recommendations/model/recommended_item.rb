module Recommendations
  module Model
    class RecommendedItem
      attr_reader :item, :value

      def initialize(item, value)
        @item=item
        @value=value
      end

      def ==(other)
        @item == other.item and @value == other.value
      end
    end
  end
end