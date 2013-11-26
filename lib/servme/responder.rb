module Servme
  class Responder

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json'
    }

    DEFAULT_OPTIONS = {
      :static_file_root_path => "dist",
      :static_file_vdir => //
    }

    attr_accessor :sinatra_app, :options

    def initialize(sinatra_app, opts)
      @sinatra_app = sinatra_app
      @options = DEFAULT_OPTIONS.merge(opts.reject { |k,v| v.nil? })
    end

    def stubber
      Stubber.instance
    end

    def respond(request)
      process_json_request(request)
      relative_path_on_disk = request.path.sub(options[:static_file_vdir], '')

      static_file = File.join(options[:static_file_root_path], relative_path_on_disk)
      stub = stubber.stub_for_request(request)
      if (stub)
        format_response(stub)
      elsif(request.path == '/')
        sinatra_app.send_file("#{options[:static_file_root_path]}/index.html")
      elsif(File.exists?(static_file))
        sinatra_app.send_file(static_file)
      else
        format_response(default_response(request))
      end
    end

    def format_response(response)
      body = json?(response) ? JSON::dump(response[:data]) : response[:data]
      [response[:status_code], response[:headers], body]
    end

    def json?(response)
      response[:headers]['Content-Type'] == 'application/json'
    end

    def default_response(request)
      {
        :headers => DEFAULT_HEADERS,
        :status_code => 404,
        :data => {
          :error => "Servme doesn't know how to respond to this request",
          :request => {
            :method => request.request_method.downcase.to_sym, #FIXME: duplication -- stubber.rb
            :params => request.params,
            :path => request.path
          }
        }
      }
    end

  private

    def process_json_request(request)
      request_params = request.params rescue nil
      if request_params && request_params.empty? && request.env && request.env['CONTENT_TYPE'] =~ /application\/json/
        parsed_json = JSON.parse(request.body.read)
        parsed_json.each do |k,v|
          request.params[k] = v
        end
      end
    end

  end
end
