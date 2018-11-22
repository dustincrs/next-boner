class ChangeProjectIsCompleteDefaultToFalse < ActiveRecord::Migration[5.2]
  def change
  	change_column_default(:projects, :is_complete, false)
  end
end
