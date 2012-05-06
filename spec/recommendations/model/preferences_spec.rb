require_relative '../../../spec/spec_helper'
require_relative '../../../lib/recommendations'
describe Recommendations::Model::Preferences do
  it "should store preferences and retrieve by user" do
    preferences = Recommendations::Model::Preferences.new
    preferences << Recommendations::Model::Preference.new('1','A',3) << Recommendations::Model::Preference.new('1','B',2)  << Recommendations::Model::Preference.new('2','A',3)
    retrieved_prefs = preferences.for_user('1')
    retrieved_prefs.size.should == 2
    retrieved_prefs[0].item.should == 'A'
    retrieved_prefs[1].item.should == 'B'
    retrieved_prefs[0].preference.should == 3
    retrieved_prefs[1].preference.should == 2
  end

  it "should store preferences and retrieve by item" do
    preferences = Recommendations::Model::Preferences.new
    preferences << Recommendations::Model::Preference.new('1','A',3) << Recommendations::Model::Preference.new('1','B',2)  << Recommendations::Model::Preference.new('2','A',4)
    retrieved_prefs = preferences.for_item('A')
    retrieved_prefs.size.should == 2
    retrieved_prefs[0].user.should == '1'
    retrieved_prefs[1].user.should == '2'
    retrieved_prefs[0].preference.should == 3
    retrieved_prefs[1].preference.should == 4
  end

  it "should store preferences and retrieve by user and item" do
    preferences = Recommendations::Model::Preferences.new
    preferences << Recommendations::Model::Preference.new('1','A',3) << Recommendations::Model::Preference.new('1','B',2)  << Recommendations::Model::Preference.new('2','A',4)
    retrieved_pref = preferences.for_user_item('1','A')
    retrieved_pref.user.should == '1'
    retrieved_pref.preference.should == 3
  end
end