require 'json'

module EndPoint
  module Handlers

    class JsonLog < Log

      def initialize(config)
        @name = config['name']
        @io = config['io']
        @filename = config['file']
      end

      ##@@ TODO enable read??

      def do_write(env, io)
        time = Time.now.to_f
        method = env['REQUEST_METHOD']
        path = env['REQUEST_PATH']
        query_string = if env['REQUEST_URI'].include?('?')
                         env['QUERY_STRING']
                       end
        remote_addr = env['REMOTE_ADDR']
        content_type = env['CONTENT_TYPE']
        headers = Hash[env.keys.select{|k| k.start_with?('HTTP_')}.map{|k| [k, env[k]]}]
        body = if !['GET', 'HEAD'].include?(method)
                 env['rack.input'].tap(&:rewind).read.to_s ##@@ TODO just do this once at higher level?
               end

        data = {
          time: time,
          method: method,
          path: path,
          query_string: query_string,
          remote_addr: remote_addr,
          content_type: content_type,
          headers: headers,
          body: body
        }

        io.puts JSON.dump(data)
      end

    end

  end
end
