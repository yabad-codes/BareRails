require 'singleton'

class Router
	include Singleton

	attr_reader :routes

	def self.draw(&blk)
		Router.instance.instance_exec(&blk)
	end

	def initialize
		@routes = {}
	end

	def get(path, &blk)
		@routes[path] = blk
	end

	def build_response(env)
		path = env['REQUEST_PATH']
		handler = @routes[path] || ->(env) { "no routes found for #{path}" }
		handler.call(env)
	end
end