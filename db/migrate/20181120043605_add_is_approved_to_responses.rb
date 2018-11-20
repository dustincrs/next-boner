class AddIsApprovedToResponses < ActiveRecord::Migration[5.2]
  def change
  	add_column(:responses, :is_approved, :boolean, default: false)
  end
end
