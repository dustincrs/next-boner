class Project < ApplicationRecord
	# Enumerations
	enum status: [:empty, :has_vacancies, :almost_full, :full]

	# Associations
	belongs_to :user
	has_many :responses
	mount_uploaders :images, ImagesUploader
end

