require File.dirname(__FILE__) + '/spec_helper'

# this spec tests against api.sandbox-soundcloud.com
# it makes the follwing assumptions
#
# the users api-test-1, api-test-2, api-test-3 exists
#
# the logged in user is api-test-1 
#
# api-test-1 follows api-test-2 but NOT api-test-3 (??)
# api-test-2 follows api-test-1 and api-test-3
# api-test-3 follows api-test-2 but NOT api-test-1
# 
# api-test-2 has 3 Tracks [Track1 (public,downloadable),Track2,Track3(private,downloadable)]
# api-test-2 has favorites: Track1 but NOT Track2
# api-test-2 has 'static-test-playlist' with Track1, 2 and 3
#
# api-test-1 has Track "static-test-track" and user api-test-3 has not permissions for it
# "static-test-track" has a comment on it.
# api-test-1 has a playlist "my-static-playlist" with at least 2 tracks


describe "Soundcloud" do  
  before(:all) do
  end
  
  it 'should create an oauth consumer' do
    Soundcloud.consumer('consumer_token','consumer_secret').should be_an_instance_of OAuth::Consumer
  end
  
  # it 'should fail to create an oauth consumer' do # !! Fail to create an OAuth consumer - we'll pass a bad secret
  #   Soundcloud.consumer('consumer_token','bad_consumer_secret').should_not be_an_instance_of OAuth::Consumer
  # end
  
  # it 'should register a client with no API key, and no OAuth' do # !! Fail to log in with no key and no oauth
  #   lambda { sc = Soundcloud.register({site => soundcloud_site})}.should raise_error # What kind of error do we want to raise here, in our final version?
  # end
  
  # it 'should register a client with a bad API key, and no OAuth' do # !! Fail to access public resources with a bad key and no OAuth
  #   sc = Soundcloud.register({:consumer_key=> invalid_consumer_key, :site => soundcloud_site})
  #   sc.to_s.should match(/Soundcloud::.+/)
  #   lambda{ sc.Track.find(:all,:params => {:order => 'hotness', :limit => 1})}.should raise_error ActiveResource::UnauthorizedAccess
  # end
  
  # it 'should register a client with a good API key and no OAuth, and be able to access public resources' do # !! Access public resources with an API key, but no OAuth
  #   sc = Soundcloud.register({:consumer_key=> valid_consumer_key, :site => soundcloud_site})
  #   sc.to_s.should match(/Soundcloud::.+/)
  #   lambda{ sc.Track.find(:all,:params => {:order => 'hotness', :limit => 1})}.should_not raise_error ActiveResource::UnauthorizedAccess
  # end
  
  it 'should register a client with a good API key and no OAuth, and fail to access private resources' do # !! Fail to access private resources with an API key, but no OAuth.
    sc = Soundcloud.register({:consumer_key=> valid_consumer_key, :site => soundcloud_site})
    sc.to_s.should match(/Soundcloud::.+/)
    lambda{ sc.User.find(:one, :from => "/me")}.should raise_error ActiveResource::UnauthorizedAccess
  end
  
  it 'should register a client with a valid oauth token, and be able to access private resources' do
    sc = Soundcloud.register({:access_token=> valid_oauth_access_token, :site => soundcloud_site})
    sc.to_s.should match(/Soundcloud::.+/)
    lambda{ sc.User.find(:one, :from => "/me")}.should_not raise_error ActiveResource::UnauthorizedAccess
  end    
end
