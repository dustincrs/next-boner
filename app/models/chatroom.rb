class Chatroom < ApplicationRecord
    has_many :subscriptions
	has_many :messages
	has_many :users, through: :subscriptions
	belongs_to :project
end
