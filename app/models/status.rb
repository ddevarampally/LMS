class Status < ApplicationRecord
	has_many :booktransactions
	has_many :books
end
