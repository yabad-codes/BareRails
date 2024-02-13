require_relative '../config/routes'

class App
	def call(env)
		headers = {
			'Content-Type' => 'text/html'
		}

		response = router.build_response(env)

		[200, headers, [response]]
	end

	private
	def router
		BareRails::Router.instance
	end
end