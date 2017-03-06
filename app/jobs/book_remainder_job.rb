class BookRemainderJob < ApplicationJob
	def perform
		due_date_of_book = DateTime.now + 1 
		borrowed_books = Book.includes(:user,:status).where(due_date: due_date_of_book,is_active: true).where.not(status_id: nil).where(statuses: {status_name: "Borrowed"})

		borrowed_books.each do |book|
			
			# Send Remainder Email Notification to Users who have borrowed book.
            BookSubscriptionMailer.book_remainder_notification_email(book).deliver_now
		end

		if borrowed_books.any?
			testing = User.where(email_address: "vnooli@capspayroll.com")

			 # Send Welcome Email Notification to newly add User.
            UserMailer.user_notification_email(testing, WELCOME_MAIL_SUBJECT).deliver_now			
		end
	end
end