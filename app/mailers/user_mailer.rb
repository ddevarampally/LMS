class UserMailer < ApplicationMailer

	def welcome_email(user)
		@user = user
		@url  = Rails.configuration.application_url + @user.user_id.to_s + '&' + { token: @user.password }.to_query 

		email_address = (@user.email_address.include? Rails.configuration.domain) ? @user.email_address : "#{@user.email_address.chomp}@#{Rails.configuration.domain}"

		mail(to: email_address, subject: 'Welcome to LMS')
	end
end
