require 'spec_helper'
describe Servme::Responder do

  let(:stubber) { Servme::Stubber.instance }
  let(:sinatra_app) { stub }
  subject { Servme::Responder.new(sinatra_app, {}) }

  before { stubber.clear }

  it "returns stubs" do
    stubber.stub(:url => "/foo", :method => :get, :params => {}, :response => {"foo" => "bar"})

    response = subject.respond(stub(:path => "/foo", :request_method => "GET", :params => {}))

    #response is a Rack response, its last entry is the resopnse body
    JSON.parse(response.last).should == {"foo" => "bar"}
  end

  it "sends static files when there is no stub" do
    File.stub(:exists? => true)
    sinatra_app.should_receive(:send_file).with("dist/foo")

    subject.respond(stub(:path => "/foo", :request_method => "GET"))
  end

  it "responds with the static index.html if the request is /" do
    sinatra_app.should_receive(:send_file).with("dist/index.html")

    subject.respond(stub(:path => "/", :request_method => "GET"))
  end

  it "allows you to specify an alternate static_file_root_path" do
    responder = Servme::Responder.new(sinatra_app, :static_file_root_path => "public")
    File.stub(:exists? => true)
    sinatra_app.should_receive(:send_file).with("public/style.css")

    responder.respond(stub(:path => "/style.css", :request_method => "GET"))
  end

  it "returns the stub if there is both a stub and a static file" do
    stubber.stub(:url => "/foo", :method => :get, :params => {}, :response => {"foo" => "bar"})
    File.stub(:exists? => true)
    sinatra_app.should_not_receive(:send_file)

    response = subject.respond(stub(:path => "/foo", :request_method => "GET", :params => {}))

    JSON.parse(response.last).should == {"foo" => "bar"}
  end

  context "when the responder is configured with some static file options" do
    subject do
      Servme::Responder.new(sinatra_app,
                            {
                              :static_file_root_path => 'build',
                              :static_file_vdir => '/vdir',
                            })
    end

    it "returns a static file response for a file in a vdir" do
      File.stub(:exists? => true)
      sinatra_app.should_receive(:send_file).with("build/foo")

      subject.respond(stub(:path => "/vdir/foo", :request_method => "GET"))
    end
  end
end
