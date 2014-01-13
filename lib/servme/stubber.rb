require 'singleton'
module Servme
  class Stubber
    include Singleton

    def initialize
      @stubbings = {}
    end

    def clear
      @stubbings = {}
    end

    def stub(config)
      (@stubbings[config[:url]] ||= {}).tap do |urls|
        (urls[config[:method] || :get] ||= {}).tap do |methods|
          methods[stringify_keys(config[:params] || {})] = {
            :data => config[:response],
            :headers => get_headers(config),
            :status_code => config[:status_code] || 200
          }
        end
      end
    end

    def get_headers(config)
      response = config[:response]

      headers = if response.is_a?(Hash)
        response.delete(:headers)
      end || {}

      headers.merge!(config[:headers] || {})

      Responder::DEFAULT_HEADERS.merge(headers)
    end

    def stub_for_request(req)
      method = req.request_method.downcase.to_sym
      begin
        @stubbings[req.path][method][req.params]
      rescue NoMethodError
        nil
      end
    end

    def stringify_keys(params)
      Hash[params.map {|(k,v)| [k.to_s, v]}]
    end
  end
end
