class User < ApplicationRecord
	has_many :booktransactions
	has_many :books
	has_many :userroles
	has_many :booksubscribers

	attr_accessor :current_password, :new_password, :confirm_password
end
