class BookRemainderJob < ApplicationJob
	def perform

		puts 'Book Remainder Job Schedule Started'

		due_date_of_book = DateTime.now + 1 
		borrowed_books = Book.includes(:user,:status).where(due_date: due_date_of_book, is_active: true).where.not(status_id: nil).where(statuses: {status_name: "Borrowed"})

		borrowed_books.each do |book|
			
			# Send Remainder Email Notification to Users who have borrowed book.
            BookRemainderMailer.book_remainder_notification_email(book).deliver_now
		end

		if borrowed_books.any? 
			puts 'Job Schedule is runnning'
		end

		puts 'Book Remainder Job Schedule Ended'

	end
end