require 'sqlite3'
require 'json'

module EndPoint
  module Handlers

    class Sqlite

      METHODS = {
        'GET' => :read,
        'POST' => :write
      }

      attr_reader :name

      def initialize(config)
        @name = config['name']
        @filename = config['file']
        @tablename = config['table'] ##@@ TODO make configurable

        ##@@ TODO check them
      end

      def connection
        @connection ||= SQLite3::Database.new(@filename)
      end

      def read?(method)
        METHODS[method] == :read
      end

      def read(env)
        connection.execute(CREATE_SQL)

        path = env['REQUEST_PATH']
        results = connection.execute(READ_SQL, path)

        ['application/json', JSON.dump(results)]
      end

      def write?(method)
        METHODS[method] == :write
      end

      def write(env)
        connection.execute(CREATE_SQL)

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
                 env['rack.input'].read.to_s
               end

        values = [time, method, path, query_string, remote_addr, content_type, JSON.dump(headers), body]
        connection.execute(INSERT_SQL, values)
      end

      READ_SQL = <<-EOS
select * from requests where path = ? order by time desc limit 10
EOS

      INSERT_SQL = <<-EOS
insert into requests
  (time, method, path, query_string, remote_address, content_type, headers, body)
  values
  (?, ?, ?, ?, ?, ?, ?, ?)
EOS

      CREATE_SQL = <<-EOS
create table if not exists requests(
  time REAL not null,
  method TEXT not null,
  path TEXT not null,
  query_string TEXT,
  remote_address TEXT not null,
  content_type TEXT,
  headers TEXT not null,
  body TEXT
);
EOS

    end

  end
end
