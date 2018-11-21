class AddIsHiddenToResponse < ActiveRecord::Migration[5.2]
  def change
  	add_column(:responses, :is_hidden, :boolean, default: false)
  end
end
