class Badge < ApplicationRecord
	# Associations
	has_many :awards
	has_many :users, through: :awards

	# Validations
	validates :rules, format: { without: /.*destroy.*/ } # For safety!

end
