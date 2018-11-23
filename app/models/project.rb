class Project < ApplicationRecord
	# CONSTANTS
	CATEGORIES = [["Select a Category", ""], "Heavy Lifting", "Food", "Automotive", "Sharing", "Advice"]

	SYMBOLS = { 
	 			clock: '<i class="far fa-clock"></i>'.html_safe,
	 			person: '<i class="fas fa-people-carry"></i>'.html_safe,
	 			map: '<i class="fas fa-map-marked-alt"></i>'.html_safe,
	 			}

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
end