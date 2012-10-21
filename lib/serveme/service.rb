require 'thin'
require 'sinatra/base'
require 'json'

module Serveme

  class Service < Sinatra::Base
    set :server, 'thin'

    get '*' do
      handle_request(:get)
    end

    post '*' do
      handle_request(:post)
    end

    def handle_request(type = :get)
      format_response(
        self.class.satisfy(
          request.path,
          type,
          request.send(type.to_s.upcase)
        )
      )
    end

    def format_response(response)
      body = json?(response) ? JSON::dump(response[:data]) : response[:data]
      [response[:status_code], response[:headers], JSON::dump(response[:data])]
    end

    def json?(response)
      response[:headers]['Content-Type'] == 'application/json'
    end

    @@stubbings = {}

    def self.clear
      @@stubbings = {}
    end


    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json'
    }

    def self.stub(config)
      (@@stubbings[config[:url]] ||= {}).tap do |urls|
        (urls[config[:method] || :get] ||= {}).tap do |methods|
          methods[stringify_keys(config[:params]) || {}] = {
            :data => config[:response],
            :headers => DEFAULT_HEADERS.merge(config[:headers] || {}),
            :status_code => config[:status_code] || 200
          }
        end
      end
    end

    def self.satisfy(path, method, params)
      @@stubbings[path][method][params] || default_response(path, method, params)
    rescue
      default_response(path, method, params)
    end

    def self.default_response(path, method, params)
      {
        :headers => DEFAULT_HEADERS,
        :status_code => 404,
        :data => {
          :error => "Serveme doesn't know how to respond to this request",
          :request => {
            :method => method,
            :params => params,
            :path => path
          }
        }
      }
    end

    def self.stringify_keys(params)
      Hash[params.map {|(k,v)| [k.to_s, v]}]
    end
  end

end