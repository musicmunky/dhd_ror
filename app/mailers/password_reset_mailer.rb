class PasswordResetMailer < ApplicationMailer
	default from: "admin@dhdadmin.com"

	def password_reset_email(user, pass)
		@user = user
		@pass = pass
		@url  = 'http://thedoghousediaries.com'
#		mail(to: @user.email, subject: 'Your DHD Admin account password has been reset')
		mail(to: "tim.w.andrews@gmail.com", subject: 'Your DHD Admin account password has been reset')
	end
end
