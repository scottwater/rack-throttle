require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Throttle::Hourly do
  include Rack::Test::Methods

  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::Hourly.new(@target_app, :max_per_hour => 3)
  end

  it "should be allowed if not seen this hour" do
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
  
  it "should be allowed if seen fewer than the max allowed per hour" do
    2.times { get "/foo" }
    expect(last_response.body).to show_allowed_response
  end
  
  it "should not be allowed if seen more times than the max allowed per hour" do
    4.times { get "/foo" }
    expect(last_response.body).to show_throttled_response
  end
  
  it "should not count last hours requests against today" do
    Timecop.freeze(DateTime.now - 1/24.0) do
      4.times { get "/foo" }
      expect(last_response.body).to show_throttled_response
    end

    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
end
