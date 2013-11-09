require 'spec_helper'

module Servme
  describe ServiceStubbing do
    def app
      Service
    end

    shared_examples_for "stubbing met" do
      Given do
        ServiceStubbing.new(request).respond_with(:woot? => "w00t!")
      end

      When { send(verb, '/foo', :bar => 'baz') }
      Then { last_response.status.should == 200 }

      Then { last_response.body.should be_json :woot? => "w00t!" }
    end

    context "GET" do
      let(:verb) { :get }
      let(:request) {
        {
          :url => "/foo",
          :method => :get,
          :params => {
            :bar => "baz"
          }
        }
      }
      it_behaves_like "stubbing met"

      describe "json responses" do
        Given do
          ServiceStubbing.new(request).respond_with(:woot? => "w00t!")
        end

        context "stubbing not met" do
          context "wrong params" do
            When { get('/foo?bar=bam') }
            Then { last_response.status.should == 404 }
          end
          context "wrong method" do
            When { post('/foo', :bar => "baz") }
            Then { last_response.status.should == 404 }
          end
        end

      end
    end

    ["GET", "PUT", "POST", "DELETE"].each do |http_verb|
      context http_verb do
        let(:verb) { http_verb.downcase.to_sym }
        let(:request) {
          {
            :url => "/foo",
            :method => verb,
            :params => {
              :bar => "baz"
            }
          }
        }
        it_behaves_like "stubbing met"
      end
    end

    describe "status code responses" do
      Given do
        ServiceStubbing.new({
          :url => "/bizness/stuff",
          :method => :post,
          :params => {
            :bizness => "true",
            :money => "12"
          }
        }).error_with(333)
      end
      When { post('/bizness/stuff', { :bizness => true, :money => 12 }) }
      Then { last_response.status.should == 333 }
    end

    describe "non-json responses" do
      Given do
        ServiceStubbing.new({
          :url => "/index",
          :method => :get,
          :headers => {
            'Content-Type' => "application/html"
          }
        }).respond_with("<html>hi</html>")
      end
      When { get('/index') }
      Then { last_response.body.should == "<html>hi</html>" }
      Then { last_response.headers['Content-Type'].should == "application/html" }
    end

  end
end