namespace :badges do
	task :populate => [:environment] do
		# CONSTANTS
		BADGE_TIERS = 	[
						"#cd7f32",
						"#B6B6B6",
						"#FFD700",
						"#4781ff",
						]

		# Helper functions
		def create_badge(rules, icon_code, icon_color, name, description)
			puts "==========================="
			puts "Making badge #{name}. With rule #{rules}"
			new_badge = Badge.new(name: name, description: description, rules: rules)
			puts "Building icon from code.."
			new_badge.icon = escape_icon_html(icon_code, icon_color)

			if(new_badge.save)
				puts "Successfully saved badge!"
			else
				puts "Failed to save badge. #{new_badge.errors.full_messages.join(", ")}"
			end
		end

		def escape_icon_html(fa_icon_code, fa_icon_color)
			return "<i class=\"#{fa_icon_code}\" style=\"color: #{fa_icon_color}\"></i>"
		end

		puts "First, destroy all existing badges..."
		Badge.destroy_all

		puts "Recreating badges from Rake task..."
		# Making badges for number of times reviewed
		review_thresholds = [5, 25, 50, 100]
		threshold_keywords = ["Keen", "Crazy", "Voracious", "Lives"]
		review_thresholds.each_with_index do |threshold, index|
			create_badge(	"user.reviews.size>=#{threshold}",
							"fas fa-edit",
							BADGE_TIERS[index],
							"#{threshold_keywords[index]} For Criticism",
							"User has been reviewed #{threshold} times."
							)
		end

		# Making badge for average rating of 4 and above
		create_badge(	"user.average_rating >= 4",
						"fas fa-star",
						BADGE_TIERS[2],
						"Customer Service",
						"User has an average rating above 4 stars.")

		# Making badges for number of completed projects participated in
		project_thresholds = [25, 50, 100, 150]
		threshold_keywords = ["Good", "Great", "Godly", "Sexy"]
		project_thresholds.each_with_index do |threshold, index|
			create_badge(	"user.successful_responses.size >= #{threshold}",
							"fas fa-award",
							BADGE_TIERS[index],
							"#{threshold_keywords[index]} Samaritan",
							"User has been part of #{threshold} completed projects.")
		end

		# And many more..
	end
end
