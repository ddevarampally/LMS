class BookRemainderMailer < ApplicationMailer

	def book_remainder_notification_email(book)
		@book_remainder = book

		mail(to: @book_remainder.user.email_address, subject: "Book Remainder")
	end
end
