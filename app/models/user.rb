class User < ApplicationRecord
  include Clearance::User

	# Associations
	has_many :projects
	has_many :responses

	# Validations
	ATTRIBUTES = User.attribute_names
	EXEMPT = ['id', 'avatar', 'is_verified', 'created_at', 'updated_at', 'encrypted_password', 'confirmation_token', 'remember_token']
	ATTRIBUTES_TO_VALIDATE = ATTRIBUTES - EXEMPT

	validates_presence_of ATTRIBUTES_TO_VALIDATE
	validate :age_over_18
	validates :phone_number, numericality: true, length: { minimum: 10, maximum: 15 }
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :email, uniqueness: true

	# Functions
	def full_name
		return "#{first_name} #{last_name}"
	end

	# Private
	private
	def age_over_18
      if (Date.today.year - date_of_birth.year < 18)
          errors.add(:date_of_birth, 'You should be 18 years or older.')
      end
	end
end
