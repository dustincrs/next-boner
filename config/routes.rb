Rails.application.routes.draw do

	root :to  => 'welcome#index'
	resources :projects
	resources :users
end
