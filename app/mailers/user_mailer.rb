class UserMailer < ApplicationMailer

	def user_notification_email(user, subject)
		@user = user
		@url  = Rails.configuration.application_url + { id: @user.user_id.to_s }.to_query + '&' + { token: @user.password }.to_query 

		@subject = subject
		mail(to: @user.email_address, subject: subject)
	end	
end
