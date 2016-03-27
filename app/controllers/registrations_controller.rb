class RegistrationsController < Devise::RegistrationsController

	private

		def sign_up_params
			params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
		end

		def account_update_params
			params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
		end

		def after_sign_out_path_for(resource_or_scope)
			dhdadmin_path
		end

end