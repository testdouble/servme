module Serveme
  class ServiceStubbing
    def initialize(request)
      @request = request
    end

    def respond_with(response)
      Service.stub(@request.merge({ :response => response }))
    end

    def error_with(status_code)
      Service.stub(@request.merge({ :status_code => status_code }))
    end
  end
end