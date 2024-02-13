require_relative '../lib/router'

Router.draw do
	get('/') { "Yabad's blog" }
	get 'articles/index'
	get 'articles/show'
end