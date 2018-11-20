class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
    	t.integer	:user_id
    	t.integer	:badge_id

		t.timestamps
    end
  end
end
