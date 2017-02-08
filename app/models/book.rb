class Book < ApplicationRecord
	has_many :bookpages
	has_many :booktransactions
	belongs_to :status
	belongs_to :user
	has_many :booksubscribers
end
