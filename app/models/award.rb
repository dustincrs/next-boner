class Award < ApplicationRecord

	# Associations
	belongs_to :user
	belongs_to :badge
end
