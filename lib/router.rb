require 'singleton'
require_relative '../app/controllers/articles_controller'
require_relative '../app/controllers/application_controller'

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
			handler = @routes[path]

			if handler
				return 200, handler.call(env)
			else
				handler = ->(env) { ApplicationController.render_error(File.expand_path("../public/status.html.erb", __dir__), locals: { title: "404 Not Found", status: "404", error: "Page not found", description: "Woops, Looks like this page doesn't exist." }) }
				return 404, handler.call(env)
			end
		end

		private
		def constantize(name)
			controller_klass_name = name.capitalize + 'Controller'
			Object.const_get(controller_klass_name)
		end
	end
end