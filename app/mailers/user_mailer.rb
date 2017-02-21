class UserMailer < ApplicationMailer

	def user_notification_email(user, subject)
		@user = user
		@url  = Rails.configuration.application_url + { id: @user.user_id.to_s }.to_query + '&' + { token: @user.password }.to_query 

		email_address = (@user.email_address.include? Rails.configuration.domain) ? @user.email_address : "#{@user.email_address.chomp}@#{Rails.configuration.domain}"

		@subject = subject
		mail(to: email_address, subject: subject)
	end	
end
