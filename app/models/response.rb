class Response < ApplicationRecord
	# Associations
	belongs_to :user
	belongs_to :project

	# Validations
	# validate :cannot_respond_more_than_once

	private
	def cannot_respond_more_than_once
		unless(Response.find_by(user_id: user_id, project_id: project_id).nil?)
			errors.add(:project_id, "Already volunteered for this project!")
		end
	end
end
