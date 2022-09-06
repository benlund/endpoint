require_relative './handlers/log'
require_relative './handlers/sqlite'
require_relative './handlers/json_log'

require 'toml-rb'

module EndPoint

  class Config

    def initialize
      @handlers = {
        'STDOUT' => EndPoint::Handlers::Log.new('name' => 'STDOUT', 'io' => $stdout)
      }

      @endpoints = {
      }

      @default_handler = 'STDOUT'
    end

    def parse_file(filename)
      config = TomlRB.load_file(filename)

      config['handler'].each do |hc|
        name = hc['name']
        klass = hc['class']

        if @handlers.has_key?(name)
          raise "Config Error: Handler #{name} already defined"
        end

        @handlers[name] = EndPoint::Handlers.const_get(klass).new(hc)
      end

      config['endpoint'].each do |ec|
        path = ec['path']

        unless path
          raise "Config error: No such path given for endpoint"
        end

        if @endpoints.has_key?(path)
          raise "Config Error: End[point #{path} already defined"
        end

       handler_names = [*ec['handlers'] || ec['handler']].compact.uniq
       handler_names.each do |n|
         unless @handlers.has_key?(n)
           raise "Config error: No such handler defined: #{n}"
         end
       end
       if handler_names.size == 0
         raise "Config error: No handlers defined for endpoint #{path}"
       end

       @endpoints[path] = handler_names
      end

      if config.has_key?('default')
        handler_names = [*config['default']['handlers'] || config['default']['handler']].compact.uniq
        handler_names.each do |n|
          unless @handlers.has_key?(n)
            raise "Config error: No such handler defined: #{n}"
          end
        end

        if handler_names.size > 1
          raise "Config Error: only one default handler allowed" ##@@ TODO why? allow more?
        end

        if handler_names[0]
          @default_handler = handler_names[0]
        end
      end
    end

    def handlers_for_path(path)
      (@endpoints[path] || [@default_handler]).map{|n| @handlers[n]}
    end

  end

end
