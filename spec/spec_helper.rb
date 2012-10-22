require 'servme'

require 'rack/test'
require 'rspec/given'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

RSpec::Matchers.define :be_json do |expected|
  match do |actual|
    actual == JSON::dump(expected)
  end
end