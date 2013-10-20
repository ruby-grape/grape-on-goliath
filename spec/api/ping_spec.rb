require 'spec_helper'

describe Acme::API do
  it "ping" do
    with_api Acme::App do
      get_request(path: "/api/ping") do |async|
        async.response.should == { ping: "pong" }.to_json
      end
    end
  end
end

