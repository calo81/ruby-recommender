require_relative '../../../spec/spec_helper'
require_relative '../../../lib/recommendations'


def preferences_for_user_1(pref_1, pref_2)
  Recommendations::Model::Preferences.new << Recommendations::Model::Preference.new('1', 'A', pref_1) << Recommendations::Model::Preference.new('1', 'B', pref_2)
end

def preferences_for_user_2(pref_1, pref_2)
  Recommendations::Model::Preferences.new << Recommendations::Model::Preference.new('2', 'A', pref_1) << Recommendations::Model::Preference.new('2', 'B', pref_2)
end

describe Recommendations::Similarity::EuclideanDistanceSimilarity do
  it "should return full similarity between two users when they have same preferences" do
    data_model = mock(:data_model)
    user_1 = '1'
    user_2 = '2'
    data_model.should_receive(:preferences_for_user).with(user_1).and_return(preferences_for_user_1(1, 2))
    data_model.should_receive(:preferences).and_return(preferences_for_user_2(1, 2))
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    user_similarity = similarity.user_similarity(user_1, user_2)
    user_similarity.should == 1
  end

  it "should return no correlation for predefined bad values" do
    data_model = mock(:data_model)
    user_1 = '1'
    user_2 = '2'
    data_model.should_receive(:preferences_for_user).with(user_1).and_return(preferences_for_user_1(3, -2))
    data_model.should_receive(:preferences).and_return(preferences_for_user_2(-3,2))
    similarity = Recommendations::Similarity::EuclideanDistanceSimilarity.new(data_model)
    user_similarity = similarity.user_similarity(user_1, user_2)
    user_similarity.should == 0.1639607805437114
  end
end