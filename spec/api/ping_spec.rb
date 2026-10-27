require 'spec_helper'

describe Acme::API do
  include Goliath::TestHelper

  # Goliath 0.9's test helper uses RSpec 2's name for a double.
  alias_method :mock, :double

  it 'ping' do
    response = nil
    with_api Acme::App do
      response = EM::HttpRequest.new('http://127.0.0.1:9900/api/ping', connect_timeout: 5, inactivity_timeout: 5).get
      stop
    end
    expect(response.response_header.status).to eq(200)
    expect(response.response).to eq({ ping: 'pong' }.to_json)
  end
end
