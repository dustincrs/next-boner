class AddDetailToProject < ActiveRecord::Migration[5.2]
  def change
  	add_column(:projects, :detail, :string)
  end
end
