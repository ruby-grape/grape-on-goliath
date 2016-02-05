require 'spec_helper'

describe Acme::API do
  include Goliath::TestHelper

  it 'ping' do
    with_api Acme::App do
      get_request(path: '/api/ping') do |async|
        expect(async.response).to eq({ ping: 'pong' }.to_json)
      end
    end
  end
end
