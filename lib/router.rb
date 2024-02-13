require 'singleton'
require_relative '../app/controllers/articles_controller'

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
		if blk
			@routes[path] = blk
		else
			if path.include? '/'
				controller, action = path.split('/')
				controller_klass_name = controller.capitalize + 'Controller'
				controller_klass = Object.const_get(controller_klass_name)
				@routes[path.prepend('/')] = ->(env) {
					controller_klass.new(env).send(action.to_sym)
				}
			end
		end
	end

	def build_response(env)
		path = env['REQUEST_PATH']
		handler = @routes[path] || ->(env) { "no routes found for #{path}" }
		handler.call(env)
	end
end