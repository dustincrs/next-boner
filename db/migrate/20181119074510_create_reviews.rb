class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
    	t.integer 	:rating
    	t.string	:text
    	t.integer	:user_id # Review target
    	t.integer 	:project_id # Associated project

		t.timestamps
    end
  end
end
