module EndPoint
  module Handlers

    class Log

      attr_reader :name

      def initialize(config)
        @name = config['name']
        @io = config['io']
        @filename = config['file']
      end

      def read?(method)
        false ##@@ TODO implement if file??
      end

      def read(env)
        raise "not implemented"
      end

      def write?(method)
        true
      end

      def write(env)
        if @filename
          File.open(@filename, 'a') do |f|
            do_write(env, f)
          end
        else
          do_write(env, @io)
        end
      end

      def do_write(env, io)
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

        io.puts 'request.time = ' + now.to_f.to_s + ' (' + now.to_s + ')'
        io.puts '>request_method = ' + request_method.to_s
        io.puts '>request_path = ' + request_path.to_s
        io.puts '>query_string = ' + query_string.to_s
        io.puts '>remote_addr = ' + remote_addr.to_s
        io.puts '>user_agent = ' + user_agent.to_s
        io.puts '>source = ' + source.to_s
        io.puts '>content_type = ' + content_type.to_s
        io.puts '>content_length = ' + content_length.to_s
        io.puts '>rack.input = ' + env['rack.input'].read.to_s
        io.puts
      end

    end

  end
end
