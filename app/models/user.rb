class User < ApplicationRecord
	has_many :booktransactions
	has_many :books
	has_many :userroles
	has_many :booksubscribers
end
