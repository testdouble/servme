require 'spec_helper'

describe Servme::Service do
  def app
    Servme::Service
  end

  describe "default responses" do
    shared_examples_for "default responses" do
      Then { last_response.headers['Content-Type'].should == 'application/json' }
      Then { last_response.status.should == 404 }
      Then do
        last_response.body.should be_json({
          :error => "Servme doesn't know how to respond to this request",
          :request => {
            :method => method,
            :params => {
              :like => "dance"
            },
            :path => "/do/stuff"
          }
        })
      end
    end

    describe "#get" do
      it_behaves_like "default responses" do
        Given(:method) { "get" }
        When { get('/do/stuff?like=dance') }
      end
    end

    describe "#post" do
      it_behaves_like "default responses" do
        Given(:method) { "post" }
        When { post('/do/stuff', {:like => "dance"}) }
      end
    end
  end



end