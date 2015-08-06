require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Throttle::Interval do
  include Rack::Test::Methods
  
  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::Interval.new(@target_app, :min => 0.1)
  end

  it "should allow the request if the source has not been seen" do
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
  
  it "should allow the request if the source has not been seen in the current interval" do
    get "/foo"
    sleep 0.2 # Should time travel this instead?
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
  
  it "should not all the request if the source has been seen inside the current interval" do
    2.times { get "/foo" }
    expect(last_response.body).to show_throttled_response
  end
  
  it "should gracefully allow the request if the cache bombs on getting" do
    allow(app).to receive(:cache_get).and_raise(StandardError)
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
  
  it "should gracefully allow the request if the cache bombs on setting" do
    allow(app).to receive(:cache_set).and_raise(StandardError)
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
end
