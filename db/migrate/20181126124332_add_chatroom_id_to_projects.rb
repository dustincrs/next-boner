class AddChatroomIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :chatroom_id, :integer
  end
end
