class Project < ApplicationRecord
	# CONSTANTS
	CATEGORIES = [["Select a Category", ""], "Heavy Lifting", "Food", "Automotive", "Sharing", "Advice"]

	SYMBOLS = { 
	 			clock: 			'<i class="far fa-clock"></i>',
	 			person: 		'<i class="fas fa-people-carry"></i>',
	 			map: 			'<i class="fas fa-map-marked-alt"></i>',
	 			heavy_lifting: 		'<i class="fas fa-weight-hanging"></i>',
	 			food:		'<i class="fas fa-drumstick-bite"></i>',
	 			automotive:		'<i class="fas fa-car"></i>',
	 			sharing: 	'<i class="fas fa-praying-hands"></i>',
	 			advice: 	'<i class="far fa-question-circle"></i>',
	 			}.map {|k, v| [k, v.html_safe]}.to_h

	# Enumerations
	enum status: [:empty, :has_vacancies, :almost_full, :full]

	# Associations
	belongs_to :user
	has_many :responses
	mount_uploaders :images, ImagesUploader

	# Validations
	validates :title, :estimated_time, :max_people, :location, :category, presence: true
	validates :max_people, numericality: { greater_than: -1 }
	validates :estimated_time, numericality: {greater_than: 0}

	# Functions
	def category_icon
		category_symbol = category.downcase.gsub(/ /, "_")
		return SYMBOLS[:"#{category_symbol}"]
	end
end