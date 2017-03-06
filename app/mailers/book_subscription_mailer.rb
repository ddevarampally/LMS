class BookSubscriptionMailer < ApplicationMailer

	def book_subscription_notification_email(book)
		@book_subscriber = book
		
		mail(to: book_subscriber.user.email_address, subject: "Book Subscription")
	end	

	def book_remainder_notification_email(book)
		@book_remainder = book
		puts  'Fired'
		mail(to: book_remainder.user.email_address, subject: "Book Remainder")
	end	
end