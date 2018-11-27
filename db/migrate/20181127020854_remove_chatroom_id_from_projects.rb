class RemoveChatroomIdFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :chatroom_id
  end
end
