class Badge < ApplicationRecord
	# Associations
	has_many :awards
	has_many :users, through: :awards

	# Validations
	validates :rules, format: { without: /.*destroy.*/ } # For safety!

	# Functions
	# Return HTML safe version of Icon
	def icon_html
		return icon.html_safe
	end

	# See if user is qualified for badges
	def self.update_badges!(user)
    # Iterates through all badges and checks if the requirement is met.
    # If so, add the user to the badge (and thus, the badge to the user)...
    # ...only if the user doesn't already have the badge.
    	Badge.all.each do |badge|
      		if(eval(badge.rules))
        		unless badge.users.include?(user)
          			badge.users << user
        		end
      		else
      			if badge.users.include?(user)
      				badge.users.delete(user)
      			end
      		end
    	end
  	end

end
