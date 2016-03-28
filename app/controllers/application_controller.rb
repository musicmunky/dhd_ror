class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	layout :layout_by_resource

	protected

	def layout_by_resource
		#if resource_name == :post_meta || resource_name == :post || devise_controller?
		if devise_controller?
			"admin"
		else
			"application"
		end
	end


end
