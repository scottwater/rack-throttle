require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Throttle::Limiter do
  include Rack::Test::Methods

  describe 'with default config' do
    def app
      @target_app ||= example_target_app
      @app ||= Rack::Throttle::Limiter.new(@target_app)
    end

    describe "basic calling" do
      it "should return the example app" do
        get "/foo"
        expect(last_response.body).to show_allowed_response
      end

      it "should call the application if allowed" do
        allow(app).to receive(:allowed?).and_return(true)
        get "/foo"
        expect(last_response.body).to show_allowed_response
      end

      it "should give a rate limit exceeded message if not allowed" do
        allow(app).to receive(:allowed?).and_return(false)
        get "/foo"
        expect(last_response.body).to show_throttled_response
      end
    end

    describe "allowed?" do
      it "should return true if whitelisted" do
        allow(app).to receive(:whitelisted?).and_return(true)
        get "/foo"
        expect(last_response.body).to show_allowed_response
      end

      it "should return false if blacklisted" do
        allow(app).to receive(:blacklisted?).and_return(true)
        get "/foo"
        expect(last_response.body).to show_throttled_response
      end

      it "should return true if not whitelisted or blacklisted" do
        allow(app).to receive(:whitelisted?).and_return(false)
        allow(app).to receive(:blacklisted?).and_return(false)
        get "/foo"
        expect(last_response.body).to show_allowed_response
      end
    end
  end

  describe 'with rate_limit_exceeded callback' do
    def app
      @target_app ||= example_target_app
      @app ||= Rack::Throttle::Limiter.new(@target_app, :rate_limit_exceeded_callback => lambda {|request| @app.callback(request) } )
    end

    it "should call rate_limit_exceeded_callback w/ request when rate limit exceeded" do
      allow(app).to receive(:blacklisted?).and_return(true)
      allow(app).to receive(:callback).and_return(true)
      get "/foo"
      expect(last_response.body).to show_throttled_response
    end
  end
end
