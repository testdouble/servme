# Servme

Servme is very rough and not ready for public consumption.

If you're still reading, servme is a test library that lets you replace some server that your application depends on with an easy-to-stub Sinatra app that can be run in a thread that's subordinate to your tests.

## Installation

Add this line to your Gemfile's test group:

    gem 'servme'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install servme

## Usage

In your spec helper:

``` ruby
Thread.new { Servme.start(:port => 12345) }
RSpec.configure do |config|
  config.include Servme::DSL
  config.after(:each) do
    Servme.reset
  end
end
```

Now, the following DSL is going to be entirely gutted ASAP, but for now, in your specs:

``` ruby
before(:each) do
  on({
    :url => "/api/login",
    :method => :post,
    :params => {
      :login => "todd",
      :password => "scotch"
    }
  }).respond_with(:token => "1234567890") }
end
```

And POSTs to "/api/login" with login "todd" and password "scotch" will get a JSON response of `{"token": "1234567890"}`.

If you want to trigger a certain status code, you can do this:

``` ruby
before(:each) do
  on({
    :url => "/api/login",
    :method => :post,
    :params => {
      :login => "todd",
      :password => "scotch"
    }
  }).error_with(401) }
end
```

All other requests will send back JSON including the request params with a 404 code.
