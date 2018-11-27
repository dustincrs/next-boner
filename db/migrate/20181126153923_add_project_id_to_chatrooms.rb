class AddProjectIdToChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :chatrooms, :project_id, :integer
  end
end
