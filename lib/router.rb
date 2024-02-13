require 'singleton'
require_relative '../app/controllers/articles_controller'

module BareRails
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
					@routes['/' + path] = ->(env) {
						controller_name, action_name = path.split('/')
						controller_klass = constantize(controller_name)

						controller = controller_klass.new(env)
						controller.send(action_name.to_sym)
						controller.render(File.expand_path("../app/views/#{controller_name}/#{action_name}.html.erb", __dir__))
					}
				end
			end
		end

		def build_response(env)
			path = env['REQUEST_PATH']
			handler = @routes[path] || ->(env) { "no routes found for #{path}" }
			handler.call(env)
		end

		private
		def constantize(name)
			controller_klass_name = name.capitalize + 'Controller'
			Object.const_get(controller_klass_name)
		end
	end
end