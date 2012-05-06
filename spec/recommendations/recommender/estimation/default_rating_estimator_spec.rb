require_relative '../../../../spec/spec_helper'
require_relative '../../../../lib/recommendations'
describe Recommendations::Recommender::Estimation::DefaultRatingEstimator do
  it "estimate rating for user and item based on neighbors" do
    data_model = mock(:data_model)
    similarity = mock(:similarity)
    user = 1
    item = 2
    neighbors = [2,3,4]
    estimator = Recommendations::Recommender::Estimation::DefaultRatingEstimator.new(data_model,similarity)
    similarity.should_receive(:user_similarity).with(1,2).and_return(0.8)
    similarity.should_receive(:user_similarity).with(1,3).and_return(0.7)
    similarity.should_receive(:user_similarity).with(1,4).and_return(0.6)
    data_model.should_receive(:preference_for_user_and_item).with(2,2).and_return(Recommendations::Model::Preference.new(2,2,4))
    data_model.should_receive(:preference_for_user_and_item).with(3,2).and_return(Recommendations::Model::Preference.new(3,2,3))
    data_model.should_receive(:preference_for_user_and_item).with(4,2).and_return(Recommendations::Model::Preference.new(4,2,5))
    estimated_value = estimator.estimate(user,neighbors,item)
    estimated_value.should == 3.9523809523809526
  end
end