require_relative '../config/routes'

class App
	def call(env)
		headers = {
			'Content-Type' => 'text/html'
		}

		status, response = router.build_response(env)

		[status, headers, [response]]
	end

	private
	def router
		BareRails::Router.instance
	end
end