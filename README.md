# Grape on Goliath

[![Tests](https://github.com/ruby-grape/grape-on-goliath/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/ruby-grape/grape-on-goliath/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/ruby-grape/grape-on-goliath/badge.svg?branch=master)](https://coveralls.io/github/ruby-grape/grape-on-goliath?branch=master)

A [Grape](https://github.com/ruby-grape/grape) API mounted on [Goliath](https://github.com/postrank-labs/goliath), a non-blocking Ruby web server framework.

* [ping](api/ping.rb): a hello world example that returns a JSON document

Tests
-----

GitHub Actions tests Goliath 0.9 on Ruby 2.7 and the latest Goliath 1.x on Ruby 2.7, 3.3, 3.4, and 4.0. Goliath's `async-rack` dependency requires Rack 1.x, so the example explicitly keeps Rack 1.6 and the compatible Grape 1.8 line rather than resolving an incompatible modern Rack/Grape combination. Ruby 2.7 jobs use Ubuntu 22.04 and JSON 2.x for compatibility with the last MultiJson releases supporting that Ruby. These legacy dependencies are retained for integration testing, not as a recommendation for new applications.

Run `bundle exec rake spec`. The Goliath 0.9 job also selects HTTP parser 0.5.3 because newer parsers remove APIs used by that server, and a compatible EM HTTP client. On the legacy stack, use `GOLIATH_VERSION='~> 0.9.0' HTTP_PARSER_VERSION='~> 0.5.3' HTTP_CLIENT_VERSION='~> 1.0.3' bundle update` and set the same variables when running tests. Matrix jobs resolve dependencies independently of the application lockfile. Run `bundle exec rubocop` for lint.

SimpleCov starts before the application loads and tracks application, API, and configuration files. CI uploads `coverage/lcov.info` from each matrix job to Coveralls and finishes the parallel coverage build after all jobs pass.

Run
---

Use Ruby 3.3 or newer with the default Goliath 1.x bundle.

```
$ bundle install
$ bundle exec ruby app.rb -sv
```

`app.rb` enables Goliath's application runner. Loading the environment for Rake or tests loads only the API, avoiding an extra server starting when those processes exit.

### Hello World

Navigate to http://localhost:9000/api/ping with a browser or use `curl`.

```
$ curl http://localhost:9000/api/ping

{"ping":"pong"}
```

List Routes
-----------

```
bundle exec rake routes
```
