require File.dirname(__FILE__) + '/spec_helper'

describe "Soundcloud::Models::Group" do 
  before(:all) do
    @sc = Soundcloud.register({:access_token=> valid_oauth_access_token, :site => soundcloud_site})

    @api_test_1 = @sc.User.find('api-test-1')    
    @api_test_2 = @sc.User.find('api-test-2')    
    @api_test_3 = @sc.User.find('api-test-3')
  end
  
  # static-test-group id = 2937
  # api_test_1 - creator
  # api_test_3 - member
  # api_test_2 track1 should be contributied
  
  it 'should find all (50) groups' do
    @sc.Group.find(:all)
  end
  
  it 'should get the fixture group' do
    group = @sc.Group.find(2937)
    group.name.should == "static-test-group"
  end
  
  
  describe 'users' do
    before do
      @group = @sc.Group.find(2937)
    end
    
    it 'should contain .. in ..' do
      
    end
  end
  
end
