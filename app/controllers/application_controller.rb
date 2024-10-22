require 'erb'

class ApplicationController
	attr_reader :env

	def initialize(env)
		@env = env
	end

	def render(view_template)
		erb_template = ERB.new File.read(view_template)
		erb_template.result(get_binding)
	end

	def self.render_error(view_template, locals: {})
		@title = locals[:title]
		@status = locals[:status]
		@error = locals[:error]
		@description = locals[:description]
		erb_template = ERB.new File.read(view_template)
		erb_template.result(binding)
	end

	def get_binding
		binding
	end
end