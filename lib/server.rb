require 'webrick'

module BareRails
	class Server
		def initialize(host = 'localhost', port = 3000)
			@host = host
			@port = port
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
			res.body = "Hello, world!"
		end
	end
end

if __FILE__ == $0
	server = BareRails::Server.new
	server.start
end