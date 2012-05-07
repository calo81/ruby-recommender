require_relative '../../../spec/spec_helper'
require_relative '../../../lib/recommendations'
describe Recommendations::Recommender::GenericUserBasedRecommender do
  it "should return correct sorted recommendations for user" do
    neighborhood = mock(:neighborhood)
    data_model = mock(:data_model)
    similarity = mock(:similarity)
    rating_estimator = mock(:rating_estimator)
    user = 1
    recommender = Recommendations::Recommender::GenericUserBasedRecommender.new(data_model, similarity, neighborhood,rating_estimator)
    neighborhood.should_receive(:user_neighborhood).with(user).and_return([2, 3, 4])
    data_model.should_receive(:items_for_users).with([2, 3, 4]).and_return([1, 2, 3, 4, 5, 6])
    data_model.should_receive(:items_for_users).with([1]).and_return([1, 2])
    rating_estimator.should_receive(:estimate).with(user, [2, 3, 4], 3).and_return(3.0)
    rating_estimator.should_receive(:estimate).with(user, [2, 3, 4], 4).and_return(4.0)
    rating_estimator.should_receive(:estimate).with(user, [2, 3, 4], 5).and_return(2.0)
    rating_estimator.should_receive(:estimate).with(user, [2, 3, 4], 6).and_return(3.5)
    recommendations = recommender.recommend(user, 3)
    recommendations.size.should == 3
    recommendations[0].item.should == 4
    recommendations[0].value.should == 4.0
    recommendations[1].item.should == 6
    recommendations[1].value.should == 3.5
    recommendations[2].item.should == 3
    recommendations[2].value.should == 3.0
  end
end