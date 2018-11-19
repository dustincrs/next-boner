class Review < ApplicationRecord
	# Associations
	belongs_to :user
	belongs_to :project

	# Validations
	validates :rating, presence: true, numericality: { minimum: 0, maximum: 5 }
	validates :user_id, :project_id, presence: true

	# CONSTANTS
	SYMBOLS = {
				star_empty: "<i class=\"far fa-star\"></i>",
				star_full: "<i class=\"fas fa-star\"></i>",
				}


	def star_rating
		result = [SYMBOLS[:star_empty]] * 5
		rating.times do |i|
			result[i] = SYMBOLS[:star_full]
		end

		return result.join("").html_safe
	end
end
