require 'webrick'
require 'webrick/https'
require 'openssl'
require_relative 'colors'
require_relative 'app'

module BareRails
	class Server
		def initialize(host = 'localhost', port = 443)
			@host = host
			@port = port
			@app = App.new
		end

		def start
			server = WEBrick::HTTPServer.new(
				Port: @port,
				SSLEnable: true,
				SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
				SSLCertificate: OpenSSL::X509::Certificate.new(File.read('server.crt')),
				SSLPrivateKey: OpenSSL::PKey::RSA.new(File.read('server.key'))
			)

			server.mount_proc '/' do |req, res|
				handle_request(req, res)
			end

			trap('INT') { server.shutdown }
			system("clear")
			puts "#{BOLD}#{GREEN}Server running at #{PURPLE}https://#{@host}:#{@port}/#{RESET}"
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