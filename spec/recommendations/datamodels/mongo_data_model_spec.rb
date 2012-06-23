require_relative '../../../spec/spec_helper'
require_relative '../../../lib/recommendations'

describe Recommendations::DataModel::MongoDataModel do
  before(:each) do
    @db = Mongo::Connection.new.db("recommender")
    @preference_collection = @db['items']
    @preference_collection.remove
    @preference_collection.insert(:user_id=>1, :item_id=>1, :preference=>3)
    @preference_collection.insert(:user_id=>1, :item_id=>2, :preference=>4)
  end

  after(:each) do
    @preference_collection.remove
  end

  it "should retrieve data model data from mongodb " do
    data_model = Recommendations::DataModel::MongoDataModel.new db:'recommender', collection: 'items'
    preferences = data_model.preferences_for_user(1)
    preferences.size.should == 2
    preferences[0].item.should == 1
    preferences[0].preference.should == 3
    preferences[1].item.should == 2
    preferences[1].preference.should == 4
  end

  it "should retrieve ditems for users" do
    @preference_collection.insert(:user_id=>1, :item_id=>2, :preference=>4)
    @preference_collection.insert(:user_id=>2, :item_id=>2, :preference=>3)
    @preference_collection.insert(:user_id=>2, :item_id=>4, :preference=>3)
    @preference_collection.insert(:user_id=>3, :item_id=>5, :preference=>3)
    data_model = Recommendations::DataModel::MongoDataModel.new db:'recommender', collection: 'items'
    data_model.items_for_users([1,2]).should == [1,2,4]
  end

  it "should set new preference for user item" do
      @preference_collection.remove
      data_model = Recommendations::DataModel::MongoDataModel.new db:'recommender', collection: 'items'
      data_model.set_preference(1,2,4.5)
      pref = @preference_collection.find({:user_id => 1})
      pref.first["item_id"].should==2
    end
end