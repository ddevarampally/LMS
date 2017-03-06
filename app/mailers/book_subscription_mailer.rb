class BookSubscriptionMailer < ApplicationMailer

	def book_subscription_notification_email(book)
		@book_subscriber = book
		
		mail(to: book_subscriber.user.email_address, subject: "Book Subscription")
	end
end
