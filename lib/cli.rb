require 'optparse'
require_relative 'server'
require_relative 'colors'

module BareRails
	class CLI
		def self.start(argv)
			new(argv).start
		end

		def initialize(argv)
			@argv = argv
		end

		def start
			option_parser.parse!(@argv)
		end

		private

		def option_parser
			OptionParser.new do |opts|
				opts.banner = "#{WHITE}#{ULINE}brails - BareRails 0.1\n\n#{RESET}Usage: brails [options]"

				opts.on("-h", "--help", "Prints this help") do
					puts opts
					exit
				end
				
				opts.on("-s", "--server", "Start the server") do
					start_server
				end

				opts.on("-c", "--console", "Initiate an IRB console") do
					start_console
				end

			end
		end

		def start_server
			server = BareRails::Server.new
			server.start
		end

		def start_console
			exec("clear; irb")
		end
	end
end

# Start the CLI if the file is executed directly
if __FILE__ == $0
	BareRails::CLI.start(ARGV)
end