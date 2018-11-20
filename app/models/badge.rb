class Badge < ApplicationRecord
	# Associations
	has_many :awards
	has_many :users, through: :awards
end
