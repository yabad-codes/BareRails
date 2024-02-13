require 'webrick'
require_relative 'colors'
require_relative 'app'

module BareRails
	class Server
		def initialize(host = 'localhost', port = 3000)
			@host = host
			@port = port
			@app = App.new
		end

		def start
			server = WEBrick::HTTPServer.new(Port: @port)
			server.mount_proc '/' do |req, res|
				handle_request(req, res)
			end

			trap('INT') { server.shutdown }
			puts "Server running at http://#{@host}:#{@port}/"
			server.start
		end

		def handle_request(req, res)
			env = {
				'REQUEST_PATH' => req.path,
				'REQUEST_METHOD' => req.request_method,
				'PATH_INFO' => req.path,
				'QUERY_STRING' => req.query_string,
			}

			status, headers, body = @app.call(env)
			res.status = status
			headers.each { |key, value| res[key] = value }
			res.body = body.join
		end
	end
end

if __FILE__ == $0
	server = BareRails::Server.new
	server.start
end