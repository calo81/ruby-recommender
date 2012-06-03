require_relative '../spec/spec_helper'
require_relative '../lib/recommendations'
require 'date'
require 'benchmark'
include Benchmark

describe "Recommendations with mongo datamodel" do

  before(:each) do
    @db = Mongo::Connection.new.db("recommender")
    #@preference_collection = @db['items']
    #@preference_collection.insert(:user_id=>'A', :item_id=>'B', :preference=>5)
    #@preference_collection.insert(:user_id=>'A', :item_id=>'C', :preference=>3)
    #@preference_collection.insert(:user_id=>'B', :item_id=>'B', :preference=>5)
    #@preference_collection.insert(:user_id=>'B', :item_id=>'C', :preference=>3)
    #@preference_collection.insert(:user_id=>'B', :item_id=>'D', :preference=>2)
  end

  after(:each) do
    #@preference_collection.remove
  end

  it "should integrate all elements and recommend accordingly" do
    data_model = Recommendations::DataModel::MongoDataModel.new db: 'recommender', collection: 'items'
    #data_model.activate_cache
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    neighborhood = Recommendations::Similarity::Neighborhood::NearestNUserNeighborhood.new(data_model, similarity, 5, 0.5, 100)
    rating_estimator = Recommendations::Recommender::Estimation::DefaultRatingEstimator.new(data_model, similarity)
    recommender = Recommendations::Recommender::GenericUserBasedRecommender.new(data_model, similarity, neighborhood, rating_estimator)
    recommender.activate_cache
    recommendations = nil
    bm(1) do |x|
      x.report("before_cache") {recommendations = recommender.recommend('9810', 5)}
      x.report("after_cached") {recommendations = recommender.recommend('9810', 5)}
    end
    recommendations.should include Recommendations::Model::RecommendedItem.new('95', 5.0)
  end
end
