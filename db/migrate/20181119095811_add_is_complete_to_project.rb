class AddIsCompleteToProject < ActiveRecord::Migration[5.2]
  def change
  	add_column(:projects, :is_complete, :boolean, default: true)
  end
end
