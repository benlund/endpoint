class EndPoint
  def initialize(config_file=nil)
    #config = Config
  end

  def call(env)
    #pp env

    server_timestamp = Time.now

    request_method = env['REQUEST_METHOD']
    request_path = env['REQUEST_PATH']
    query_string = env['QUERY_STRING']

    remote_addr = env['REMOTE_ADDR']
    user_agent = env['HTTP_USER_AGENT']
    source = env['HTTP_SOURCE']

    content_type = env['CONTENT_TYPE']
    content_length = env['CONTENT_LENGTH']

    ## TODO check max content length

    now = Time.now
    puts 'request.time = ' + now.to_f.to_s + ' (' + now.to_s + ')'
    puts '>request_method = ' + request_method.to_s
    puts '>request_path = ' + request_path.to_s
    puts '>query_string = ' + query_string.to_s
    puts '>remote_addr = ' + remote_addr.to_s
    puts '>user_agent = ' + user_agent.to_s
    puts '>source = ' + source.to_s
    puts '>content_type = ' + content_type.to_s
    puts '>content_length = ' + content_length.to_s
    puts '>rack.input = ' + env['rack.input'].read.to_s
    puts

    response_code = 200
    response_content_type = 'text/plain'
    response_str = 'OK'
    response_content_length = response_str.bytesize.to_s


    [
      response_code,
      {"Content-Type" => response_content_type,
       "Content-Length" => response_content_length
      },
      [response_str]
    ]
  end
end
