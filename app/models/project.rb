class Project < ApplicationRecord
	# Associations
	belongs_to :user
	has_many :responses
end
