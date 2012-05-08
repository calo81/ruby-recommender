require_relative '../spec/spec_helper'
require_relative '../lib/recommendations'

describe "Recommendations with mongo datamodel" do

  before(:each) do
    @db = Mongo::Connection.new.db("recommender")
    @preference_collection = @db['items']
    @preference_collection.insert(:user_id=>'A', :item_id=>'B', :preference=>5)
    @preference_collection.insert(:user_id=>'A', :item_id=>'C', :preference=>3)
    @preference_collection.insert(:user_id=>'B', :item_id=>'B', :preference=>5)
    @preference_collection.insert(:user_id=>'B', :item_id=>'C', :preference=>3)
    @preference_collection.insert(:user_id=>'B', :item_id=>'D', :preference=>2)
  end

  after(:each) do
    @preference_collection.remove
  end

  it "should integrate all elements and recommend accordingly" do
    data_model = Recommendations::DataModel::MongoDataModel.new db:'recommender', collection: 'items'
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    neighborhood = Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood.new(data_model,similarity,5,0.5)
    rating_estimator = Recommendations::Recommender::Estimation::DefaultRatingEstimator.new(data_model,similarity)
    recommender = Recommendations::Recommender::GenericUserBasedRecommender.new(data_model,similarity,neighborhood,rating_estimator)
    recommendations = recommender.recommend('A',5)
    recommendations.should == [Recommendations::Model::RecommendedItem.new('D',2.0)]
  end
end