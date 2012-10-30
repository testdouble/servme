module Servme
  class ServiceStubbing
    def initialize(request)
      @request = request
    end

    def respond_with(response)
      Stubber.instance.stub(@request.merge({ :response => response }))
    end

    def error_with(status_code)
      Stubber.instance.stub(@request.merge({ :status_code => status_code }))
    end
  end
end
