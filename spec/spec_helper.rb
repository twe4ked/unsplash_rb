$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'unsplash'
require 'vcr'
require 'pry'

Unsplash.configure do |config|
  config.application_id = "baaa6a1214d50b3586bec6e06157aab859bd4d86dc0b755360f103f38974edc3"
  config.application_secret = "bb834160d12304045c55d0c0ec2eb0fe62a5fe249bc1a392386120d55eb2793a"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.register_request_matcher :auth_header do |request_1, request_2|
    request_1.headers["Authorization"] == request_2.headers["Authorization"]
  end
end


RSpec.configure do |config|

  config.order = "random"

  config.before :each do
    Unsplash::Client.connection = Unsplash::Connection.new(
                                  api_base_uri:   "http://api.lvh.me:3000",
                                  oauth_base_uri: "http://www.lvh.me:3000")
  end

end


def stub_oauth_authorization
  token = "69cca388c56e64fc2ee1c9f7cfb0dcec1bf1b384957b61c9ec6764777b98554e"
  client = Unsplash::Client.connection.instance_variable_get(:@oauth)
  access_token = ::OAuth2::AccessToken.new(client, token)
  Unsplash::Client.connection.instance_variable_set(:@oauth_token, access_token)
end
