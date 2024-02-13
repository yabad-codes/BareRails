require_relative '../lib/router'

Router.draw do
	get('/') do |env|
		puts "Path: #{env['REQUEST_PATH']}"
		"Yabad's blog"
	end
end