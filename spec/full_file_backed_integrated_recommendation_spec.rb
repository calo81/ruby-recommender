require_relative '../spec/spec_helper'
require_relative '../lib/recommendations'

describe "Recommendations with file data model" do
  it "should integrate all elements and recommend accordingly" do
    save_as_csv_file '/tmp/data_file',[['A','B',5],['A','C',3],['B','B',5],['B','C',3],['B','D',2]]
    data_model = Recommendations::DataModel::FileDataModel.new('/tmp/data_file')
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    neighborhood = Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood.new(data_model,similarity,5,0.5)
    rating_estimator = Recommendations::Recommender::Estimation::DefaultRatingEstimator.new(data_model,similarity)
    recommender = Recommendations::Recommender::GenericUserBasedRecommender.new(data_model,similarity,neighborhood,rating_estimator)
    recommendations = recommender.recommend('A',5)
    recommendations.should == [Recommendations::Model::RecommendedItem.new('D',2.0)]
  end

  it "should work for bigger file" do
    data_model = Recommendations::DataModel::FileDataModel.new('/tmp/u.data')
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    neighborhood = Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood.new(data_model,similarity,5,0.5)
    rating_estimator = Recommendations::Recommender::Estimation::DefaultRatingEstimator.new(data_model,similarity)
    recommender = Recommendations::Recommender::GenericUserBasedRecommender.new(data_model,similarity,neighborhood,rating_estimator)
    recommendations = recommender.recommend('225',5)
    recommendations.size.should == 5
  end

  it "should work for biggest file" do
    data_model = Recommendations::DataModel::FileDataModel.new('/tmp/u-large.data')
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    neighborhood = Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood.new(data_model,similarity,5,0.5)
    rating_estimator = Recommendations::Recommender::Estimation::DefaultRatingEstimator.new(data_model,similarity)
    recommender = Recommendations::Recommender::GenericUserBasedRecommender.new(data_model,similarity,neighborhood,rating_estimator)
    recommendations = recommender.recommend('225',5)
    recommendations.size.should == 5
  end
end