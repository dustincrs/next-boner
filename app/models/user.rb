class User < ApplicationRecord
  include Clearance::User
  attr_accessor :avatar
  mount_uploader :avatar, AvatarUploader


  # Enumerations
  enum role: [:normal, :moderator, :superadmin, :bot]

  # Associations
  has_many :authentications, dependent: :destroy

  has_many :projects
  has_many :responses
  has_many :reviews
  has_many :awards
  has_many :badges, through: :awards
  has_many :messages
  has_many :subscriptions
  has_many :chatrooms, through: :subscriptions
  has_many :messages

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
  # Return full name
  def full_name
    return "#{first_name} #{last_name}"
  end

  # Returns average review ratings. This function is bad when DB is huge.
  # Consider custom Rake task and adding a column for the avg in the user table.
  def average_rating
    if(reviews.size <= 0)
      return 0
    else
      return reviews.map { |r| r.rating }.sum/reviews.size
    end
  end

  # Returns all users responses that were approved, and that are marked as complete
  def successful_responses
    return responses.select {|r| r.project.is_complete == true}
  end

  def blurb
    tagger = EngTagger.new
    all_reviews_tagged = tagger.add_tags(reviews.map { |r| r.text }.join(" ").gsub(/\n/, " "))
    all_adjectives = tagger.get_adjectives(all_reviews_tagged)

    unless(all_adjectives.nil?)
      adjectives = all_adjectives.keys.sample(3).join(", ")
      blurb = "Previously described as #{adjectives}."
      return blurb
    end

    return ""
  end

  # Returns true if the user is the owner of the project, a moderator, or an admin
  def can_view_project_detail?(project_object)
    (id == project_object.user.id || moderator? || superadmin? || project_object.responses.where(user_id: id).size > 0)? true : false
  end

  def can_view_project_controls?(project_object)
    (id == project_object.user.id || moderator? || superadmin?)? true : false
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
      avatar: auth_hash["info"]["image"],
      phone_number: phone_no,

      password: SecureRandom.hex(10),


    )
    user.authentications << authentication
    return user
  end

  def google_token
    x = self.authentications.find_by(provider: 'google_oauth2')
    return x.token unless x.nil?
  end

  def facebook_token
    x = self.authentications.find_by(provider: 'facebook')
    return x.token unless x.nil?
  end

  # Private
  private
  def age_over_18
    if date_of_birth != nil
      if (Date.today.year - date_of_birth.year < 18)
        errors.add(:date_of_birth, 'You should be 18 years or older.')
      end
    end
  end
end
