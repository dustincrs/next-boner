class User < ApplicationRecord
  include Clearance::User

	# Associations
	has_many :projects
	has_many :responses
end
