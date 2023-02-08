# EndPoint

Almost the simplest-imaginable API endpoint server.

By default EndPoint will:

* Accept every single request - any method on any URL with any content
* Write the URL, headers, body, time, and ip address of every request to stdout
* Repond with 200 OK


EndPoint can be configured to:

* Write to other destinations instead of (or as well as) stdout:
  * Append to a plaint-text file
  * Append to a newline-separated JSON file
  * Insert into a SQLite table
* Write to different destinations for different URL paths
* Read from (instead of write to) the SQLite table on GET requests


EndPoint was written to support my IoT-device experiments without having to build (or program against) a custom API. My hobby projects just POST their data to EndPoint and then I deal with it later.


## Usage


    $ ENDPOINT_CONFIG=config.toml bundle exec puma


## Configuration

Suppose you had two remote devices, one submitting readings every so often and one just pinging home. Let's say you wanted the readings to go into a database, but the pings to be just written to a file. Any other requests should be written to stdout. Here's an example configuration file for that:

    #config.toml

    [[handler]]
    name = "DB"
    class = "Sqlite"
    file = "/path/to/endpoint.db"
    table = "requests"

    [[handler]]
    name = "LOG"
    class = "Log"
    file = "/path/to/endpoint.log"


    [[endpoint]]
    path = "/readings"
    handlers = ["DB"]

    [[endpoint]]
    path = "/pings"
    handlers = ["LOG"]


    [default]
    handler = "STDOUT"


See also `config.toml.example` for a fuller example.


## Status

An accurate version number would be 0.0.9 - it works for my most basic use case but could benefit from some polishing up.
