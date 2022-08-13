require './endpoint.rb'

run EndPoint.new(ENV['ENDPOINT_CONFIG'])
# run ->(env) do
#   pp env
#   [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
# end
