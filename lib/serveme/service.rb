require 'goliath'
require 'json'

module Serveme

  class Service < Goliath::API
    @@stubbings = {}

    def self.clear
      @@stubbings = {}
    end

    def self.stub(config)
      (@@stubbings[config[:url]] ||= {}).tap do |urls|
        (urls[config[:method] || :get] ||= {}).tap do |methods|
          methods[config[:params] || {}] = {
            :data => config[:response],
            :headers => {},
            :status_code => config[:status_code] || 200
          }
        end
      end
    end

    def self.satisfy(env)
      @@stubbings[env["REQUEST_PATH"]][env["REQUEST_METHOD"].downcase.to_sym][params_for(env)]
    end

    def self.params_for(env)
      Hash[env["rack.input"].read.split('&').map do |pair|
        key, value = pair.split('=')
        [key.to_sym, value]
      end]
    end

    def response(env)
      response = self.class.satisfy(env)
      [response[:status_code], response[:headers], JSON::dump(response[:data])]
    end
  end

end