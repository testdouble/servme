require 'thin'
require 'sinatra/base'
require 'json'

module Servme

  class Service < Sinatra::Base
    set :server, 'thin'

    get '*' do
      responder.respond(request)
    end

    post '*' do
     responder.respond(request)
    end

    put '*' do
      responder.respond(request)
    end

    delete '*' do
      responder.respond(request)
    end

    def responder
      @responder ||= Responder.new(self, {})
    end

    def self.clear
      Stubber.instance.clear
    end
  end

end
