class Initial < ActiveRecord::Migration[5.2]
  def change
	create_table :users do |t|
		t.string 	:first_name
		t.string 	:last_name
		t.date		:date_of_birth
		t.string	:phone_number
		t.string	:email
		t.string	:avatar
		t.boolean	:is_verified

		t.timestamps
	end

	create_table :projects do |t|
		t.string	:title
		t.string	:category
		t.integer	:estimated_time # in minutes!
		t.integer	:max_people
		t.string	:location
		t.float		:latitude
		t.float		:longitude
		t.json		:images

		t.timestamps
	end

	create_table :responses do |t|
		t.integer 	:user_id
		t.integer 	:project_id

		t.timestamps
	end
  end
end
