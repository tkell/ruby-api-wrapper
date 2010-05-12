require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))


require 'soundcloud'

Spec::Runner.configure do |config|
  
end

def soundcloud_site
  'http://api.sandbox-soundcloud.com'
end

def soundcloud_settings
  return  {
          :access_token => 'AsgdxDulQmk45AawcPI3g', 
          :access_secret => 'NXfAc1nheU8ufUDojrcmPHb1Pf1N6ZlHu9xYogAvAY',
          :consumer_token => '74CAKi2MhN6FIIUgR5YnA',
          :consumer_secret => 'sM2XjxpwyIaZRuiCHjSp9p1FfLZQvyqLbTU0hhLBNXY', 
          :bad_consumer_token => '98ydfg',
          :bad_consumer_secret => 'Sp9p1FTU0hhLBNXY'
          }
end

def valid_oauth_access_token
  access_token = soundcloud_settings[:access_token]
  access_secret = soundcloud_settings[:access_secret]
  consumer_token = soundcloud_settings[:consumer_token]
  consumer_secret = soundcloud_settings[:consumer_secret]

  sc_consumer = Soundcloud.consumer(consumer_token,consumer_secret,soundcloud_site)
  return OAuth::AccessToken.new(sc_consumer, access_token, access_secret)
end

