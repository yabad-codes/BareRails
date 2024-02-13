require_relative '../lib/router'

BareRails::Router.draw do
	get('/') { "Yabad's blog" }
	get 'articles/index'
	get 'articles/show'
end