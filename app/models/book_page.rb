class BookPage < ApplicationRecord
	belongs_to :book, optional: true
end
