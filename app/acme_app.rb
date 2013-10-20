module Acme
  class App < Goliath::API
    use Goliath::Rack::Params
    use Goliath::Rack::Render

    def response(env)
      Acme::API.call(env)
    end
  end
end
