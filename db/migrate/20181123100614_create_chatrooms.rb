class CreateChatrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chatrooms do |t|
      t.text :topic
      t.text :slug

      t.timestamps
    end
  end
end
