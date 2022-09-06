require_relative './lib/endpoint/app'

run EndPoint::App.new(ENV['ENDPOINT_CONFIG'])
