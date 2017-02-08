class BookTransaction < ApplicationRecord
	belongs_to :status
	belongs_to :book
	belongs_to :user
end
