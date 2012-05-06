require_relative '../../../spec/spec_helper'
require_relative '../../../lib/recommendations'
describe Recommendations::DataModel::FileDataModel do
  it "should load data model from the passed CSV file" do
      save_as_csv_file '/tmp/data_file',[['A','B',1],['A','C',3],['B','B',5],['B','C',3],['B','D',2]]
      data_model = Recommendations::DataModel::FileDataModel.new '/tmp/data_file'
      preferences = data_model.preferences_for_user('A')
      preferences.size.should == 2
      preferences[0].item.should == 'B'
      preferences[0].preference.should==1
  end

  it "should return items for users" do
    save_as_csv_file '/tmp/data_file',[['A','B',1],['A','C',3],['B','B',5],['B','C',3],['B','D',2]]
    data_model = Recommendations::DataModel::FileDataModel.new '/tmp/data_file'
    data_model.items_for_users(['A','B']).should == ['B','C','D']
  end
end