class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
    	t.string	:rules
    	t.string	:icon 	# Uses FontAwesome HTML <i>
    	t.string	:name
    	t.string	:description
    	
		t.timestamps
    end
  end
end
