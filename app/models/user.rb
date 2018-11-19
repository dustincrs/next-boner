class User < ApplicationRecord
	# Associations
	has_many :projects
	has_many :responses
end
