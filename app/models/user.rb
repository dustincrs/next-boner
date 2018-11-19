class User < ApplicationRecord
  	include Clearance::User

	# Associations
	has_many :authentications, dependent: :destroy

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


	# Google OmniAuth
	def self.create_with_auth_and_hash(authentication, auth_hash)
		first_name = auth_hash["info"]["name"].split(" ").first
	    last_name = auth_hash["info"]["name"].split(" ").last
	    # TAKE ME OUT LATER
	    dob = 69.years.ago.to_date
	    phone_no = "1234567890"

		user = self.create!(
		 first_name: first_name,
		 last_name: last_name,
		 date_of_birth: dob,
		 email: auth_hash["info"]["email"],
		 phone_number: phone_no,
		 password: SecureRandom.hex(10)
		)
		user.authentications << authentication
		return user
	end

	def google_token
		x = self.authentications.find_by(provider: 'google_oauth2')
		return x.token unless x.nil?
	end

	# Private
	private
	def age_over_18
      if (Date.today.year - date_of_birth.year < 18)
          errors.add(:date_of_birth, 'You should be 18 years or older.')
      end
	end
end
