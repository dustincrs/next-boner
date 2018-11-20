class Project < ApplicationRecord
	# Associations
	belongs_to :user
	has_many :responses
	mount_uploaders :images, ImagesUploader
end
