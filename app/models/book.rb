class Book < ApplicationRecord
	has_many :bookpages
	has_many :booktransactions
	belongs_to :status, optional: true
	belongs_to :user, optional: true
	has_many :booksubscribers
end
