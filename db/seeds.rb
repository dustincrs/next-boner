# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def report_seeding(saved, total, type)
	puts "Seeded #{saved} out of #{total} #{type}."
end


def generate_user(role)
	u = User.new()
	u.first_name = Faker::Name.first_name
	u.last_name = Faker::Name.last_name
	u.date_of_birth = Faker::Date.birthday(18, 75)
	u.phone_number = "1234567890"
	u.email = Faker::Internet.email
	u.password = "1234567890"
	return u
end

def generate_test_user
	u = User.new()
	u.first_name = Faker::Name.first_name
	u.last_name = Faker::Name.last_name
	u.date_of_birth = Faker::Date.birthday(18, 75)
	u.phone_number = "1234567890"
	u.email = "test@email.com"
	u.password = "1234567890"
	return u
end

def generate_project(owner_id)
	n_p = Project.new()
	n_p.title = Faker::Hipster.sentence
	n_p.category = Project::CATEGORIES[1..-1].sample
	n_p.estimated_time = rand(361)
	n_p.max_people = rand(11)
	n_p.location = Faker::Address.street_address
	n_p.latitude = Faker::Address.latitude
	n_p.longitude = Faker::Address.longitude
	n_p.user_id = owner_id
	n_p.is_complete = Faker::Boolean.boolean(0.5)
	n_p.detail = Faker::Hipster.paragraphs(1 + rand(6)).join(" ")
	return n_p
end


def generate_response(user_id, project_id)
	r = Response.new()
	r.user_id = user_id
	r.project_id = project_id
	r.is_approved = Faker::Boolean.boolean(0.85)
	r.is_hidden = Faker::Boolean.boolean(0.2)
	return r
end

def generate_reviews(target_user_id, project_id)
	r = Review.new()
	r.rating = rand(6)
	r.text = Faker::Hipster.paragraph(rand(3))
	r.user_id = target_user_id
	r. project_id = project_id
	return r
end

# Seed Normal Users
users_to_seed = 25
seeded_users = 0
users_to_seed.times do
	u = generate_user("normal")
	if(u.save)
		seeded_users += 1
	end
end

report_seeding(seeded_users, users_to_seed, "users")

# Seed a test account
if generate_test_user.save
	puts "Seeded test@email.com, password: 1234567890"
else
	puts "Failed to seed test user!"
end


# Seed projects
total_projects = 0
saved_projects = 0
User.all.each do |user|
	rand(15).times do
		total_projects += 1
		new_project = generate_project(user.id)
		if(new_project.save)
			saved_projects += 1
			new_chatroom = Chatroom.create(project_id: new_project.id)
		end
	end
end

report_seeding(saved_projects, total_projects, "projects")

# Seed responses
total_responses = 0
saved_responses = 0
Project.all.each do |project|
	User.all.sample(2 + rand(11)).each do |user|
		total_responses += 1
		new_response = generate_response(user.id, project.id)

		if(new_response.save)
			saved_responses += 1
		end
	end
end

report_seeding(saved_responses, total_responses, "responses")

# Take out responses where max_people are exceeded
Project.all.each do |project|
	while(project.responses.where(is_approved: true).size > project.max_people)
		project.responses.last.destroy
	end
end

# Seed reviews
total_reviews = 0
saved_reviews = 0
Response.joins(:project).where(projects: {is_complete: true}).each do |response|
	total_reviews += 1
	new_review = generate_reviews(response.user_id, response.project_id)

	if(new_review.save)
		saved_reviews += 1
	end
end

report_seeding(saved_reviews, total_reviews, "reviews")


# Seed admin account
admin = generate_user("admin")
admin.email = "admin@test.com"

if(admin.save)
	puts "Successfully created admin!"
else
	puts "FAILED TO SEED ADMIN ACCOUNT! #{admin.errors.full_messages}"
end

# Seed moderator account
moderator = generate_user("moderator")
moderator.email = "moderator@test.com"

if(moderator.save)
	puts "Successfully created moderator!"
else
	puts "FAILED TO SEED MODERATOR ACCOUNT!"
end