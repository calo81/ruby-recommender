require_relative '../../../../spec/spec_helper'
require_relative '../../../../lib/recommendations'

describe Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood do
      it "should return the top N users similar to passed user" do
        data_model = mock(:data_model)
        similarity = mock(:similarity)
        user = 1
        neighborhood = Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood.new(data_model,similarity,2,0.75)
        data_model.should_receive(:users).and_return([1,2,3,4,5])
        similarity.should_receive(:user_similarity).with(1,2).and_return(0.68)
        similarity.should_receive(:user_similarity).with(1,3).and_return(0.78)
        similarity.should_receive(:user_similarity).with(1,4).and_return(0.77)
        similarity.should_receive(:user_similarity).with(1,5).and_return(0.79)
        neighbors = neighborhood.user_neighborhood(user)
        neighbors.size.should == 2
        neighbors[0].should == 5
        neighbors[1].should == 3
      end
end