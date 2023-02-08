require_relative './config'

module EndPoint

  class App

    def initialize(config_file=nil)
      @config = EndPoint::Config.new
      if config_file
        @config.parse_file(config_file)
      end
    end

    def call(env)
      response_code = 200
      response_content_type = 'text/plain'
      response_body = 'OK'

      method = env['REQUEST_METHOD']
      path = env['REQUEST_PATH']

      ## TODO make sure all handlers get same request_time @@

      handlers = @config.handlers_for_path(path)
      handlers.each do |handler|

        begin
          ok = false
          read = false

          if handler.write?(method)
            handler.write(env)
            ok = true
          end

          if !read && handler.read?(method)
            response_content_type, response_body = handler.read(env)
            ok = true
            read = true
          end

          if !ok
            response_code = 405
            response_body = 'Method Not Allowed'
          end

        rescue StandardError => e
          ## TODO should go to stderr
          puts e
          puts e.backtrace
          response_code = 500
          response_body = 'Error'
        end

      end

      response_content_length = response_body.bytesize

      puts [Time.now, method, path, handlers.map(&:name), response_code, response_content_length].map(&:inspect).join(' ')

      [
        response_code,
        {"Content-Type" => response_content_type,
         "Content-Length" => response_content_length.to_s
        },
        [response_body]
      ]
    end

  end

end
