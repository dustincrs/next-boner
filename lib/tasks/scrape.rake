namespace :scrape do
  desc "Makes the bot account for posting projects"
  task setup: :environment do

  	if(User.where(role: "bot").size == 0)
	  	bot = User.new()
		bot.first_name = "Scrapy"
		bot.last_name = "Bot"
		bot.date_of_birth = Faker::Date.birthday(18, 75)
		bot.phone_number = "1234567890"
		bot.email = "scrapy@email.com"
		bot.password = "1234567890"
		bot.bot!

		if(bot.save)
			puts "Created Scrapy bot!"
		else
			puts "Couldn't make Scrapy, #{bot.errors.full_messages.join(", ")}"
		end

	else
		puts "Scrapy already exists!"
	end
  end

  desc "TODO"
  task eventbrite: :environment do
  	def create_project_from_event_page_url(url)
		event_page = Nokogiri::HTML(open(url))

		new_project = User.find_by(role: "bot").projects.build()
		new_project.title = event_page.css("h1.listing-hero-title").text
		new_project.category = "Scraped"

		start_time = event_page.css("meta[property='event:start_time']").first[:content].to_datetime
		end_time = event_page.css("meta[property='event:end_time']").first[:content].to_datetime

		new_project.estimated_time = ((end_time - start_time)*24*60).to_i #mins

		new_project.max_people = 0

		new_project.location = event_page.css("p.listing-map-card-street-address.text-default").text.gsub(/\n\t*/, "")
		new_project.latitude = event_page.css("meta[property='event:location:latitude']").first[:content]
		new_project.longitude = event_page.css("meta[property='event:location:longitude']").first[:content]

		new_project.detail = event_page.css("div[data-automation='listing-event-description'] p").map { |e| e.text }.join("\n")

		if(Project.exists?(user_id: User.find_by(role: "bot").id, title: new_project.title))
			puts "Not making project, it already has been scraped!"
		else
			if(new_project.save)
				puts "Successfully scraped and made project #{new_project.title}!"
			else
				puts "Error: #{new_project.errors.full_messages.join(", ")}"
			end
		end
  	end


  	eb_urls_to_scrape = [	"https://www.eventbrite.com/d/singapore--singapore/charity-and-causes--events--this-month/?page=1",
  							"https://www.eventbrite.com/d/malaysia--kuala-lumpur/charity-and-causes--events--this-month/?page=1",
  						]

  	eb_urls_to_scrape.each do |url|
		doc = Nokogiri::HTML(open(url))
		event_links = doc.css("div.eds-media-card-content__primary-content a").map { |e| e[:href]}.uniq

		event_links.each do |event|
			create_project_from_event_page_url(event)
		end
	end
  end
end